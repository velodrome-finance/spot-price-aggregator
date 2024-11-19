// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOffchainOracle.s.sol";

contract DeployOffchainOracleLisk is DeployOffchainOracle {
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
        wrappers = new IWrapper[](0);

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
        connectors = new IERC20[](6);
        connectors[0] = IERC20(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF); // NONE
        connectors[1] = IERC20(0x05D032ac25d322df992303dCa074EE7392C117b9); // USDT
        connectors[2] = IERC20(0xF242275d3a6527d877f2c927a82D9b057609cc71); // USDC.e
        connectors[3] = IERC20(0x4200000000000000000000000000000000000006); //WETH
        connectors[4] = IERC20(0xac485391EB2d7D88253a7F1eF18C37f4242D1A24); //LSK
        connectors[5] = IERC20(0x7f9AdFbd38b669F03d1d11000Bc76b9AaEA28A81); //XVELO
    }
}
