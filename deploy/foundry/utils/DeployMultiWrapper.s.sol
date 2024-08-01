// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/Base.s.sol";

contract DeployMultiWrapper is Base {
    struct MultiWrapperParams {
        IWrapper[] existingWrappers;
        address owner;
    }

    MultiWrapperParams public multiWrapperParams;
    MultiWrapper public multiWrapper;

    function deployMultiWrapper()
        internal
    {
        multiWrapper = new MultiWrapper(multiWrapperParams.existingWrappers, multiWrapperParams.owner);
        _writeContractAddress("MultiWrapper", address(multiWrapper));
    }
}
