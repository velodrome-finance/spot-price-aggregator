// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOffchainOracle.s.sol";

contract DeployOffchainOracleOptimism is DeployOffchainOracle {
    address public constant OWNER = 0xBA4BB89f4d1E66AA86B60696534892aE0cCf91F5;

    IERC20[] public connectors;

    function run() public {
        vm.startBroadcast();
        _getMultiWrapper();
        _getOracles();
        _getConnectors();

        offchainOracleParams = OffchainOracleParams({
            multiWrapper: multiWrapper,
            existingOracles: oracles,
            oracleTypes: oracleTypes,
            existingConnectors: connectors,
            wBase: IERC20(0x4200000000000000000000000000000000000006),
            owner: OWNER
        });

        deployOffchainOracle();
        vm.stopBroadcast();
    }

    function _getMultiWrapper() internal {
        IWrapper[] memory existingWrappers = new IWrapper[](2);
        existingWrappers[0] = IWrapper(0x0c8fc7a71C28c768FDC1f7d75835229beBEB1573);
        existingWrappers[1] = IWrapper(0x1A75DF59f464a70Cc8f7383983852FF72e5F5167);

        multiWrapperParams = MultiWrapperParams({
            existingWrappers: existingWrappers,
            owner:OWNER
        });

        deployMultiWrapper();
    }

    function _getOracles() internal {
        oracles = new IOracle[](2);
        oracles[0] = IOracle(0xD4eFb5998DFBDFB791182fb610D0061136E9DB50);
        oracles[1] = IOracle(0xeD55d76Bb48E042a177d1E21AffBe1B72d0c7dB0);

        oracleTypes = new OffchainOracle.OracleType[](2);
        oracleTypes[0] = OffchainOracle.OracleType.WETH;
        oracleTypes[1] = OffchainOracle.OracleType.WETH;
    }

    function _getConnectors() internal {
        connectors = new IERC20[](9);

        connectors[0] = IERC20(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF);
        connectors[1] = IERC20(0x4200000000000000000000000000000000000006);//weth
        connectors[2] = IERC20(0x7F5c764cBc14f9669B88837ca1490cCa17c31607);//usdc bridged
        connectors[3] = IERC20(0x94b008aA00579c1307B0EF2c499aD98a8ce58e58);//usdt
        connectors[4] = IERC20(0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1);//dai
        connectors[5] = IERC20(0x0b2C639c533813f4Aa9D7837CAf62653d097Ff85);//usdc native
        connectors[6] = IERC20(0x1F32b1c2345538c0c6f582fCB022739c4A194Ebb);// wstETH,
        connectors[7] = IERC20(0x4200000000000000000000000000000000000042);// OP,
        connectors[8] = IERC20(0x8c6f28f2F1A3C87F0f938b96d27520d9751ec8d9);// sUSD
    }
}
