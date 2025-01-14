// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/Base.s.sol";
import "contracts/wrappers/AaveWrapperV2.sol";
import "contracts/wrappers/AaveWrapperV3.sol";
import "contracts/wrappers/BaseCoinWrapper.sol";
import "contracts/wrappers/ChaiWrapper.sol";
import "contracts/wrappers/CompoundLikeWrapper.sol";
import "contracts/wrappers/CompoundV3Wrapper.sol";
import "contracts/wrappers/FulcrumWrapper.sol";
import "contracts/wrappers/FulcrumWrapperLegacy.sol";
import "contracts/wrappers/SDaiWrapper.sol";
import "contracts/wrappers/StataTokenWrapper.sol";
import "contracts/wrappers/WstETHWrapper.sol";
import "contracts/wrappers/YVaultWrapper.sol";

abstract contract DeployMultiWrapper is Base {
    enum WrapperEnum {
        AaveWrapperV2,
        AaveWrapperV3,
        BaseCoinWrapper,
        ChaiWrapper,
        CompoundLikeWrapper,
        CompoundV3Wrapper,
        FulcrumWrapper,
        FulcrumWrapperLegacy,
        SDaiWrapper,
        StataTokenWrapper,
        WstETHWrapper,
        YVaultWrapper
    }

    mapping(string => WrapperEnum) private _stringToWrapperEnum;

    IWrapper[] private wrappers;

    MultiWrapper public multiWrapper;

    function _deployMultiWrapper() internal {
        if (address(multiWrapper) != address(0)) {
            return;
        }

        _setWrapperMapping();

        uint256 length = params.wrapperNames.length;
        wrappers = new IWrapper[](length);
        for (uint256 i = 0; i < length; i++) {
            wrappers[i] = _deployWrapper(params.wrapperNames[i], params.wrapperParams[i]);
        }

        multiWrapper = new MultiWrapper(wrappers, params.owner);
        _writeContractAddress("MultiWrapper", address(multiWrapper));
    }

    function _deployWrapper(string memory _wrapperName, address[] memory _addressParams)
        private
        returns (IWrapper wrapper)
    {
        _setWrapperMapping();

        if (_stringToWrapperEnum[_wrapperName] == WrapperEnum.AaveWrapperV2) {
            wrapper = IWrapper(new AaveWrapperV2(ILendingPoolV2(_addressParams[0])));
        } else if (_stringToWrapperEnum[_wrapperName] == WrapperEnum.AaveWrapperV3) {
            wrapper = IWrapper(new AaveWrapperV3(ILendingPoolV3(_addressParams[0])));
        } else if (_stringToWrapperEnum[_wrapperName] == WrapperEnum.BaseCoinWrapper) {
            wrapper = IWrapper(new BaseCoinWrapper(IERC20(_addressParams[0]), IERC20(_addressParams[1])));
        } else if (_stringToWrapperEnum[_wrapperName] == WrapperEnum.ChaiWrapper) {
            wrapper = IWrapper(
                new ChaiWrapper(IERC20(_addressParams[0]), IERC20(_addressParams[1]), IChaiPot(_addressParams[2]))
            );
        } else if (_stringToWrapperEnum[_wrapperName] == WrapperEnum.CompoundLikeWrapper) {
            wrapper = IWrapper(new CompoundLikeWrapper(IComptroller(_addressParams[0]), IERC20(_addressParams[1])));
        } else if (_stringToWrapperEnum[_wrapperName] == WrapperEnum.CompoundV3Wrapper) {
            wrapper = IWrapper(new CompoundV3Wrapper(_addressParams[0]));
        } else if (_stringToWrapperEnum[_wrapperName] == WrapperEnum.FulcrumWrapper) {
            wrapper = IWrapper(new FulcrumWrapper());
        } else if (_stringToWrapperEnum[_wrapperName] == WrapperEnum.FulcrumWrapperLegacy) {
            wrapper = IWrapper(new FulcrumWrapperLegacy(_addressParams[0]));
        } else if (_stringToWrapperEnum[_wrapperName] == WrapperEnum.SDaiWrapper) {
            wrapper = IWrapper(new SDaiWrapper(IERC20(_addressParams[0]), IERC20(_addressParams[1])));
        } else if (_stringToWrapperEnum[_wrapperName] == WrapperEnum.StataTokenWrapper) {
            wrapper = IWrapper(new StataTokenWrapper(IStaticATokenFactory(_addressParams[0])));
        } else if (_stringToWrapperEnum[_wrapperName] == WrapperEnum.WstETHWrapper) {
            wrapper = IWrapper(new WstETHWrapper(IERC20(_addressParams[0]), IERC20(_addressParams[1])));
        } else if (_stringToWrapperEnum[_wrapperName] == WrapperEnum.YVaultWrapper) {
            wrapper = IWrapper(new YVaultWrapper());
        }
        _writeContractAddress(_wrapperName, address(wrapper));

        if (address(wrapper) == address(0)) {
            revert("Wrapper name not found.");
        }
    }

    function _setWrapperMapping() private {
        _stringToWrapperEnum["AaveWrapperV2"] = WrapperEnum.AaveWrapperV2;
        _stringToWrapperEnum["AaveWrapperV3"] = WrapperEnum.AaveWrapperV3;
        _stringToWrapperEnum["BaseCoinWrapper"] = WrapperEnum.BaseCoinWrapper;
        _stringToWrapperEnum["ChaiWrapper"] = WrapperEnum.ChaiWrapper;
        _stringToWrapperEnum["CompoundLikeWrapper"] = WrapperEnum.CompoundLikeWrapper;
        _stringToWrapperEnum["CompoundV3Wrapper"] = WrapperEnum.CompoundV3Wrapper;
        _stringToWrapperEnum["FulcrumWrapper"] = WrapperEnum.FulcrumWrapper;
        _stringToWrapperEnum["FulcrumWrapperLegacy"] = WrapperEnum.FulcrumWrapperLegacy;
        _stringToWrapperEnum["SDaiWrapper"] = WrapperEnum.SDaiWrapper;
        _stringToWrapperEnum["StataTokenWrapper"] = WrapperEnum.StataTokenWrapper;
        _stringToWrapperEnum["WstETHWrapper"] = WrapperEnum.WstETHWrapper;
        _stringToWrapperEnum["YVaultWrapper"] = WrapperEnum.YVaultWrapper;
    }
}
