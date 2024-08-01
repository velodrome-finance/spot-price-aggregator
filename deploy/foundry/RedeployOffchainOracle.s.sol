// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOffchainOracle.s.sol";

contract RedeployOffchainOracle is DeployOffchainOracle {
    function _setOffchainOracle() internal {
        OffchainOracle oldOffchainOracle = OffchainOracle(_getOffchainOracle());
        (IOracle[] memory allOracles, OffchainOracle.OracleType[] memory oracleTypes) = oldOffchainOracle.oracles();

        //The following 2 lines should be correctly set
        IERC20 wBase = IERC20(0x4200000000000000000000000000000000000006);
        address owner = address(0);

        offchainOracleParams = OffchainOracleParams({
            multiWrapper: oldOffchainOracle.multiWrapper(),
            existingOracles: allOracles,
            oracleTypes: oracleTypes,
            existingConnectors: oldOffchainOracle.connectors(),
            wBase: wBase,
            owner: owner
        });
    }

    function run() public {
        _setOffchainOracle();
        deployOffchainOracle();
    }
}
