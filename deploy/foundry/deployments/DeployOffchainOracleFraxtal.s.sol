// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOffchainOracle.s.sol";

contract DeployOffchainOracleFraxtal is DeployOffchainOracle {
    address public constant OWNER = 0x607EbA808EF2685fAc3da68aB96De961fa8F3312;

    IERC20[] public connectors;

    function setUp() public override {
        chainName = "FRAXTAL";
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
            wBase: IERC20(0xFC00000000000000000000000000000000000006),
            owner: OWNER
        });

        deployOffchainOracle();
        vm.stopBroadcast();
    }

    function _getMultiWrapper() internal {
        wrappers = new IWrapper[](1);

        // frxETH -> wfrxETH
        wrappers[0] = new BaseCoinWrapper(
            IERC20(0x0000000000000000000000000000000000000000),
            IERC20(0xFC00000000000000000000000000000000000006)
        );

        multiWrapperParams = MultiWrapperParams({existingWrappers: wrappers, owner: OWNER});

        deployMultiWrapper();
    }

    function _getOracles() internal {
        oracleParams = new OracleParams[](2);

        // velov2
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

        // slipstream
        address slipstreamFactory = 0x04625B046C69577EfC40e6c0Bb83CDBAfab5a55F;

        bytes memory slipstreamBytecodeCreate2 = abi.encodePacked(
            hex"3d602d80600a3d3981f3363d3d373d3d3d363d73",
            0x321f7Dfb9B2eA9131B8C17691CF6e01E5c149cA8,
            hex"5af43d82803e903d91602b57fd5bf3"
        );
        bytes32 slipstreamInitcodeHash = keccak256(slipstreamBytecodeCreate2);
        addressParams[0] = slipstreamFactory;

        uint24[] memory uint24Params = new uint24[](5);
        uint24Params[0] = 1;
        uint24Params[1] = 50;
        uint24Params[2] = 100;
        uint24Params[3] = 200;
        uint24Params[4] = 2_000;

        oracleParams[1] = OracleParams({
            oracleName: "UniswapV3LikeOracle",
            addressParams: addressParams,
            bytesParams: slipstreamInitcodeHash,
            uint24Params: uint24Params,
            oraclekind: OffchainOracle.OracleType.WETH
        });

        deployOracles();
    }

    function _getConnectors() internal {
        connectors = new IERC20[](8);

        connectors[0] = IERC20(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF); // NONE
        connectors[1] = IERC20(0xFc00000000000000000000000000000000000001); // FRAX
        connectors[2] = IERC20(0xFC00000000000000000000000000000000000006); // wfrxETH
        connectors[3] = IERC20(0xFC00000000000000000000000000000000000005); // sfrxETH
        connectors[4] = IERC20(0x5d3a1Ff2b6BAb83b63cd9AD0787074081a52ef34); // USDe
        connectors[5] = IERC20(0x211Cc4DD073734dA055fbF44a2b4667d5E5fE5d2); // sUSDe
        connectors[6] = IERC20(0xDcc0F2D8F90FDe85b10aC1c8Ab57dc0AE946A543); // USDC
        connectors[7] = IERC20(0x4200000000000000000000000000000000000006); // WETH
    }
}
