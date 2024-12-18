// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import "@openzeppelin/contracts/utils/math/Math.sol";
import "./OracleBase.sol";
import "../interfaces/IOracle.sol";
import "../interfaces/IUniswapV2Pair.sol";
import "../libraries/OraclePrices.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SolidlyOracle is IOracle {
    using OraclePrices for OraclePrices.Data;
    using Math for uint256;

    address public immutable FACTORY;
    bytes32 public immutable INITCODE_HASH;

    IERC20 private constant _NONE = IERC20(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF);

    constructor(address _factory, bytes32 _initcodeHash) {
        FACTORY = _factory;
        INITCODE_HASH = _initcodeHash;
    }

    function getRate(IERC20 srcToken, IERC20 dstToken, IERC20 connector, uint256 thresholdFilter)
        external
        view
        override
        returns (uint256 rate, uint256 weight)
    {
        if (connector == _NONE) {
            (rate, weight) = _getWeightedRate(srcToken, dstToken, thresholdFilter);
        } else {
            (uint256 rateC0, uint256 weightC0) = _getWeightedRate(srcToken, connector, thresholdFilter);
            (uint256 rateC1, uint256 weightC1) = _getWeightedRate(connector, dstToken, thresholdFilter);
            rate = rateC0 * rateC1 / 1e18;
            weight = Math.min(weightC0, weightC1);
        }
    }

    function _getWeightedRate(IERC20 srcToken, IERC20 dstToken, uint256 thresholdFilter)
        internal
        view
        returns (uint256 rate, uint256 weight)
    {
        OraclePrices.Data memory ratesAndWeights = OraclePrices.init(2);
        (uint256 b0, uint256 b1) = _getBalances(srcToken, dstToken, true);
        if (b1 > 0) {
            ratesAndWeights.append(OraclePrices.OraclePrice(_stableRate(srcToken, dstToken), (b0 * b1).sqrt()));
        }
        (b0, b1) = _getBalances(srcToken, dstToken, false);
        if (b0 > 0) {
            ratesAndWeights.append(OraclePrices.OraclePrice(Math.mulDiv(b1, 1e18, b0), (b0 * b1).sqrt()));
        }
        (rate, weight) = ratesAndWeights.getRateAndWeight(thresholdFilter);
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function _pairFor(IERC20 tokenA, IERC20 tokenB, bool stable) private view returns (address pair) {
        pair = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            hex"ff", FACTORY, keccak256(abi.encodePacked(tokenA, tokenB, stable)), INITCODE_HASH
                        )
                    )
                )
            )
        );
    }

    function _getBalances(IERC20 srcToken, IERC20 dstToken, bool stable)
        internal
        view
        returns (uint256 srcBalance, uint256 dstBalance)
    {
        (IERC20 token0, IERC20 token1) = srcToken < dstToken ? (srcToken, dstToken) : (dstToken, srcToken);
        (bool success, bytes memory data) =
            _pairFor(token0, token1, stable).staticcall(abi.encodeWithSelector(IUniswapV2Pair.getReserves.selector));
        if (success && data.length == 96) {
            (srcBalance, dstBalance) = abi.decode(data, (uint256, uint256));
            (srcBalance, dstBalance) = srcToken == token0 ? (srcBalance, dstBalance) : (dstBalance, srcBalance);
        } else {
            (srcBalance, dstBalance) = (1, 0);
        }
    }

    function _stableRate(IERC20 srcToken, IERC20 dstToken) internal view returns (uint256 rate) {
        uint8 srcTokenDecimals = ERC20(address(srcToken)).decimals();

        (IERC20 token0, IERC20 token1) = srcToken < dstToken ? (srcToken, dstToken) : (dstToken, srcToken);
        address currentPair = _pairFor(token0, token1, true);

        (bool success, bytes memory data) = currentPair.staticcall(
            abi.encodeWithSelector(IUniswapV2Pair.getAmountOut.selector, 10 ** srcTokenDecimals, address(srcToken))
        );
        if (success) {
            uint256 outputAmount = abi.decode(data, (uint256));
            rate = Math.mulDiv(outputAmount, 1e18, (10 ** srcTokenDecimals));
        } else {
            rate = 0;
        }
    }
}
