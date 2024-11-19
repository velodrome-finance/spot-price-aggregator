// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOffchainOracle.s.sol";

contract DeployOffchainOracleBob is DeployOffchainOracle {
    address public constant OWNER = 0x607EbA808EF2685fAc3da68aB96De961fa8F3312;

    IERC20[] public connectors;

    function setUp() public override {
        chainName = "BOB";
    }

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

        //shoebill
        addressParams[0] = 0x9f53Cd350c3aC49cE6CE673abff647E5fe79A3CC;
        addressParams[1] = 0xb4255533Ad74A25A83d17154cB48A287E8f6A811;
        wrapperParams[0] = WrapperParams({wrapperName: "CompoundLikeWrapper", addressParams: addressParams});

        //layerbank
        addressParams[0] = 0x77cabFd057Bd7C81c011059F1bf74eC1fBeDa971;
        addressParams[1] = 0xbd00E7923775C781D1BF0cAE4e0de8EFe8B60ccB;
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
        connectors = new IERC20[](5);
        connectors[0] = IERC20(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF);
        connectors[1] = IERC20(0x4200000000000000000000000000000000000006); //weth
        connectors[2] = IERC20(0xe75D0fB2C24A55cA1e3F96781a2bCC7bdba058F0); //usdc bridged
        connectors[3] = IERC20(0x05D032ac25d322df992303dCa074EE7392C117b9); //usdt
        connectors[4] = IERC20(0x03C7054BCB39f7b2e5B2c7AcB37583e32D70Cfa3); //wbtc
    }
}
