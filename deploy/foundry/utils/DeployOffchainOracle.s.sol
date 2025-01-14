// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOracle.s.sol";
import "deploy/foundry/utils/DeployMultiWrapper.s.sol";

abstract contract DeployOffchainOracle is DeployMultiWrapper, DeployOracle {
    OffchainOracle public offchainOracle;

    function setUp() public virtual override;

    function run() public {
        vm.startBroadcast(deployer);
        _deployMultiWrapper();
        _deployOracles();
        _deployOffchainOracle();
        vm.stopBroadcast();
    }

    function _deployOffchainOracle() internal {
        offchainOracle = new OffchainOracle({
            _multiWrapper: multiWrapper,
            existingOracles: oracles,
            oracleTypes: params.oracleTypes,
            existingConnectors: params.connectors,
            wBase: params.wBase,
            owner_: params.owner
        });

        _writeContractAddress("OffchainOracle", address(offchainOracle));
    }
}
