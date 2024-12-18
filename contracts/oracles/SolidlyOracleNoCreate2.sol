// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import "@openzeppelin/contracts/utils/math/Math.sol";
import "./OracleBase.sol";
import "../interfaces/ISolidlyFactory.sol";
import "../interfaces/IOracle.sol";
import "../interfaces/IUniswapV2Pair.sol";
import "../libraries/OraclePrices.sol";

contract SolidlyOracleNoCreate2 is IOracle {
    using OraclePrices for OraclePrices.Data;
    using Math for uint256;

    ISolidlyFactory public immutable FACTORY;

    IERC20 private constant _NONE = IERC20(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF);

    constructor(ISolidlyFactory _factory) {
        FACTORY = _factory;
    }

    function getRate(IERC20 srcToken, IERC20 dstToken, IERC20 connector, uint256 thresholdFilter)
        external
        view
        override
        returns (uint256 rate, uint256 weight)
    {
        if (connector != _NONE) revert ConnectorShouldBeNone();
        OraclePrices.Data memory ratesAndWeights = OraclePrices.init(2);
        (uint256 b0, uint256 b1) = _getBalances(srcToken, dstToken, true);
        ratesAndWeights.append(OraclePrices.OraclePrice(Math.mulDiv(b1, 1e18, b0), (b0 * b1).sqrt()));
        (b0, b1) = _getBalances(srcToken, dstToken, false);
        ratesAndWeights.append(OraclePrices.OraclePrice(Math.mulDiv(b1, 1e18, b0), (b0 * b1).sqrt()));
        return ratesAndWeights.getRateAndWeight(thresholdFilter);
    }

    function _getBalances(IERC20 srcToken, IERC20 dstToken, bool stable)
        internal
        view
        returns (uint256 srcBalance, uint256 dstBalance)
    {
        (IERC20 token0, IERC20 token1) = srcToken < dstToken ? (srcToken, dstToken) : (dstToken, srcToken);
        (bool success, bytes memory data) = FACTORY.getPair(token0, token1, stable).staticcall(
            abi.encodeWithSelector(IUniswapV2Pair.getReserves.selector)
        );
        if (success && data.length == 96) {
            (srcBalance, dstBalance) = abi.decode(data, (uint256, uint256));
            (srcBalance, dstBalance) = srcToken == token0 ? (srcBalance, dstBalance) : (dstBalance, srcBalance);
        } else {
            (srcBalance, dstBalance) = (1, 0);
        }
    }
}
