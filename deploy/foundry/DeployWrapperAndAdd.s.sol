// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployWrapper.s.sol";
import "contracts/MultiWrapper.sol";

contract DeployWrapperAndAdd is DeployWrapper {
    function _setWrappersParams() internal {
        // wrapperParams = new WrapperParams[](1);
        // wrapperParams[0] = WrapperParams("AaveWrapperV2", new address[](1));
        // wrapperParams[0].addressParams[0] = 0x0000000000000000000000000000000000000000;
    }

    function run() public {
        OffchainOracle offchainOracle = OffchainOracle(_getOffchainOracle());
        MultiWrapper multiWrapper = offchainOracle.multiWrapper();

        deployWrappers();

        for (uint256 i = 0; i < wrappers.length; i++) {
            multiWrapper.addWrapper(wrappers[i]);
        }
    }
}
