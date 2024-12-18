// SPDX-License-Identifier: MIT

// solhint-disable one-contract-per-file

pragma solidity 0.8.23;

import "./OracleBase.sol";

interface ISyncswapFactory {
    function getPool(address tokenA, address tokenB) external view returns (address pool);
}

interface ISyncswapPool {
    function getReserves() external view returns (uint256, uint256);
}

contract SyncswapOracle is OracleBase {
    ISyncswapFactory public immutable FACTORY;

    constructor(ISyncswapFactory _factory) {
        FACTORY = _factory;
    }

    function _getBalances(IERC20 srcToken, IERC20 dstToken)
        internal
        view
        override
        returns (uint256 srcBalance, uint256 dstBalance)
    {
        (IERC20 token0, IERC20 token1) = srcToken < dstToken ? (srcToken, dstToken) : (dstToken, srcToken);
        address pool = FACTORY.getPool(address(token0), address(token1));
        if (pool == address(0)) revert PoolNotFound();
        (uint256 reserve0, uint256 reserve1) = ISyncswapPool(pool).getReserves();
        (srcBalance, dstBalance) = srcToken == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }
}
