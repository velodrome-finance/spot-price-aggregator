// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOffchainOracle.s.sol";

contract DeployOffchainOracleBase is DeployOffchainOracle {
    address public constant OWNER = 0xE6A41fE61E7a1996B59d508661e3f524d6A32075;

    IERC20[] public connectors;

    function setUp() public override {
        chainName = "BASE";
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
        multiWrapper = MultiWrapper(0x84BfCeFf9B6fdbC6862E08CcB8D685bc101Ff840);
    }

    function _getOracles() internal {
        oracles = new IOracle[](2);
        oracles[0] = IOracle(0xedAEc518e432F4627F23f0a069fd43a4051161C6);
        oracles[1] = IOracle(0x7d57F783A9B8f1Ac1605ff291c8556C592b4bF78);

        oracleTypes = new OffchainOracle.OracleType[](2);
        oracleTypes[0] = OffchainOracle.OracleType.WETH;
        oracleTypes[1] = OffchainOracle.OracleType.WETH;

        oracles = new IOracle[](2);

        oracleParams = new OracleParams[](2);

        oracleTypes = new OffchainOracle.OracleType[](2);
        oracleTypes[0] = OffchainOracle.OracleType.WETH;
        oracleTypes[1] = OffchainOracle.OracleType.WETH;

        address[] memory addressParams = new address[](1);

        bytes32 aerodromeInitCodeHash = 0x6f178972b07752b522a4da1c5b71af6524e8b0bd6027ccb29e5312b0e5bcdc3c;
        addressParams[0] = 0x420DD381b31aEf6683db6B902084cB0FFECe40Da; //aerodrome factory

        oracleParams[0] = OracleParams({
            oracleName: "SolidlyOracle",
            addressParams: addressParams,
            bytesParams: aerodromeInitCodeHash,
            uint24Params: new uint24[](0),
            oraclekind: OffchainOracle.OracleType.WETH
        });

        address slipstreamFactory = 0x5e7BB104d84c7CB9B682AaC2F3d509f5F406809A;
        address slipstreamPoolImplementation = 0xeC8E5342B19977B4eF8892e02D8DAEcfa1315831;

        bytes memory slipstreamBytecodeCreate2 = abi.encodePacked(
            hex"3d602d80600a3d3981f3363d3d373d3d3d363d73",
            slipstreamPoolImplementation,
            hex"5af43d82803e903d91602b57fd5bf3"
        );
        bytes32 slipstreamInitcodeHash = keccak256(slipstreamBytecodeCreate2);
        require(
            slipstreamInitcodeHash == bytes32(0xffb9af9ea6d9e39da47392ecc7055277b9915b8bfc9f83f105821b7791a6ae30),
            "INITCODE_HASH"
        );

        addressParams = new address[](1);
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
        connectors = new IERC20[](4);

        connectors[0] = IERC20(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF);
        connectors[1] = IERC20(0x4200000000000000000000000000000000000006);
        connectors[2] = IERC20(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913);
        connectors[3] = IERC20(0x50c5725949A6F0c72E6C4a641F24049A917DB0Cb);
    }
}
