// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOffchainOracle.s.sol";

contract DeployOffchainOracleMode is DeployOffchainOracle {
    address public constant OWNER = 0xe915AEf46E1bd9b9eD2D9FE571AE9b5afbDE571b;

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
        wrapperParams = new WrapperParams[](2);

        address[] memory addressParams = new address[](2);

        //ionic
        addressParams[0] = 0xFB3323E24743Caf4ADD0fDCCFB268565c0685556;
        addressParams[1] = 0x71ef7EDa2Be775E5A7aa8afD02C45F059833e9d2;
        wrapperParams[0] = WrapperParams({wrapperName: "CompoundLikeWrapper", addressParams: addressParams});

        //layerbank
        addressParams[0] = 0x80980869D90A737aff47aBA6FbaA923012C1FF50;
        addressParams[1] = 0xe855B8018C22A05F84724e93693caf166912aDD5;
        wrapperParams[1] = WrapperParams({wrapperName: "CompoundLikeWrapper", addressParams: addressParams});

        deployWrappers();

        multiWrapperParams = MultiWrapperParams({existingWrappers: wrappers, owner: OWNER});

        deployMultiWrapper();
    }

    function _getOracles() internal {
        oracleParams = new OracleParams[](1);

        address velodromeFactory = 0x31832f2a97Fd20664D76Cc421207669b55CE4BC0;

        bytes memory veloBytecodeCreate2 = abi.encodePacked(
            hex"3d602d80600a3d3981f3363d3d373d3d3d363d73",
            0x10499d88Bd32AF443Fc936F67DE32bE1c8Bb374C,
            hex"5af43d82803e903d91602b57fd5bf3"
        );
        bytes32 velodromeInitcodeHash = keccak256(veloBytecodeCreate2);

        address[] memory addressParams = new address[](1);
        addressParams[0] = velodromeFactory;

        oracleParams[0] = OracleParams({
            oracleName: "SolidlyOracle",
            addressParams: addressParams,
            bytesParams: velodromeInitcodeHash,
            uint24Params: new uint24[](0),
            oraclekind: OffchainOracle.OracleType.WETH
        });

        deployOracles();
    }

    function _getConnectors() internal {
        connectors = new IERC20[](4);
        connectors[0] = IERC20(0x4200000000000000000000000000000000000006); //weth
        connectors[1] = IERC20(0xDfc7C877a950e49D2610114102175A06C2e3167a); //mode
        connectors[2] = IERC20(0xd988097fb8612cc24eeC14542bC03424c656005f); //usdc
        connectors[3] = IERC20(0xf0F161fDA2712DB8b566946122a5af183995e2eD); //usdt
    }
}
