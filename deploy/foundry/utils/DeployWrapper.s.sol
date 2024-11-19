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

abstract contract DeployWrapper is Base {
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

    struct WrapperParams {
        string wrapperName;
        address[] addressParams;
    }

    mapping(string => WrapperEnum) public stringToWrapperEnum;

    WrapperParams[] public wrapperParams;
    IWrapper[] public wrappers;

    function deployWrappers() internal {
        _setWrapperMapping();

        wrappers = new IWrapper[](wrapperParams.length);
        for (uint256 i = 0; i < wrapperParams.length; i++) {
            wrappers[i] = _deployWrapper(wrapperParams[i]);
        }
    }

    function _deployWrapper(WrapperParams memory _wrapperParams) internal returns (IWrapper wrapper) {
        _setWrapperMapping();
        string memory wrapperName = _wrapperParams.wrapperName;

        if (stringToWrapperEnum[wrapperName] == WrapperEnum.AaveWrapperV2) {
            wrapper = IWrapper(new AaveWrapperV2(ILendingPoolV2(_wrapperParams.addressParams[0])));
        } else if (stringToWrapperEnum[wrapperName] == WrapperEnum.AaveWrapperV3) {
            wrapper = IWrapper(new AaveWrapperV3(ILendingPoolV3(_wrapperParams.addressParams[0])));
        } else if (stringToWrapperEnum[wrapperName] == WrapperEnum.BaseCoinWrapper) {
            wrapper = IWrapper(
                new BaseCoinWrapper(IERC20(_wrapperParams.addressParams[0]), IERC20(_wrapperParams.addressParams[1]))
            );
        } else if (stringToWrapperEnum[wrapperName] == WrapperEnum.ChaiWrapper) {
            wrapper = IWrapper(
                new ChaiWrapper(
                    IERC20(_wrapperParams.addressParams[0]),
                    IERC20(_wrapperParams.addressParams[1]),
                    IChaiPot(_wrapperParams.addressParams[2])
                )
            );
        } else if (stringToWrapperEnum[wrapperName] == WrapperEnum.CompoundLikeWrapper) {
            wrapper = IWrapper(
                new CompoundLikeWrapper(
                    IComptroller(_wrapperParams.addressParams[0]), IERC20(_wrapperParams.addressParams[1])
                )
            );
        } else if (stringToWrapperEnum[wrapperName] == WrapperEnum.CompoundV3Wrapper) {
            wrapper = IWrapper(new CompoundV3Wrapper(_wrapperParams.addressParams[0]));
        } else if (stringToWrapperEnum[wrapperName] == WrapperEnum.FulcrumWrapper) {
            wrapper = IWrapper(new FulcrumWrapper());
        } else if (stringToWrapperEnum[wrapperName] == WrapperEnum.FulcrumWrapperLegacy) {
            wrapper = IWrapper(new FulcrumWrapperLegacy(_wrapperParams.addressParams[0]));
        } else if (stringToWrapperEnum[wrapperName] == WrapperEnum.SDaiWrapper) {
            wrapper = IWrapper(
                new SDaiWrapper(IERC20(_wrapperParams.addressParams[0]), IERC20(_wrapperParams.addressParams[1]))
            );
        } else if (stringToWrapperEnum[wrapperName] == WrapperEnum.StataTokenWrapper) {
            wrapper = IWrapper(new StataTokenWrapper(IStaticATokenFactory(_wrapperParams.addressParams[0])));
        } else if (stringToWrapperEnum[wrapperName] == WrapperEnum.WstETHWrapper) {
            wrapper = IWrapper(
                new WstETHWrapper(IERC20(_wrapperParams.addressParams[0]), IERC20(_wrapperParams.addressParams[1]))
            );
        } else if (stringToWrapperEnum[wrapperName] == WrapperEnum.YVaultWrapper) {
            wrapper = IWrapper(new YVaultWrapper());
        }
        _writeContractAddress(_wrapperParams.wrapperName, address(wrapper));

        if (address(wrapper) == address(0)) {
            revert("Wrapper name not found.");
        }
    }

    function _setWrapperMapping() private {
        stringToWrapperEnum["AaveWrapperV2"] = WrapperEnum.AaveWrapperV2;
        stringToWrapperEnum["AaveWrapperV3"] = WrapperEnum.AaveWrapperV3;
        stringToWrapperEnum["BaseCoinWrapper"] = WrapperEnum.BaseCoinWrapper;
        stringToWrapperEnum["ChaiWrapper"] = WrapperEnum.ChaiWrapper;
        stringToWrapperEnum["CompoundLikeWrapper"] = WrapperEnum.CompoundLikeWrapper;
        stringToWrapperEnum["CompoundV3Wrapper"] = WrapperEnum.CompoundV3Wrapper;
        stringToWrapperEnum["FulcrumWrapper"] = WrapperEnum.FulcrumWrapper;
        stringToWrapperEnum["FulcrumWrapperLegacy"] = WrapperEnum.FulcrumWrapperLegacy;
        stringToWrapperEnum["SDaiWrapper"] = WrapperEnum.SDaiWrapper;
        stringToWrapperEnum["StataTokenWrapper"] = WrapperEnum.StataTokenWrapper;
        stringToWrapperEnum["WstETHWrapper"] = WrapperEnum.WstETHWrapper;
        stringToWrapperEnum["YVaultWrapper"] = WrapperEnum.YVaultWrapper;
    }
}
