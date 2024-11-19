// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOracle.s.sol";
import "deploy/foundry/utils/DeployWrapper.s.sol";
import "deploy/foundry/utils/DeployMultiWrapper.s.sol";

abstract contract DeployOffchainOracle is DeployMultiWrapper, DeployOracle, DeployWrapper {
    struct OffchainOracleParams {
        MultiWrapper multiWrapper;
        IOracle[] existingOracles;
        OffchainOracle.OracleType[] oracleTypes;
        IERC20[] existingConnectors;
        IERC20 wBase;
        address owner;
    }

    OffchainOracleParams public offchainOracleParams;

    OffchainOracle public offchainOracle;

    function deployOffchainOracle() internal {
        offchainOracle = new OffchainOracle({
            _multiWrapper: offchainOracleParams.multiWrapper,
            existingOracles: offchainOracleParams.existingOracles,
            oracleTypes: offchainOracleParams.oracleTypes,
            existingConnectors: offchainOracleParams.existingConnectors,
            wBase: offchainOracleParams.wBase,
            owner_: offchainOracleParams.owner
        });

        _writeContractAddress("OffchainOracle", address(offchainOracle));
    }
}
