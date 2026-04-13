// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOffchainOracle.s.sol";

contract DeployOffchainOracleBase is DeployOffchainOracle {
    address public constant OWNER = 0xE6A41fE61E7a1996B59d508661e3f524d6A32075;

    function setUp() public override {
        //setting Multiwrapper since there's no need to deploy it
        multiWrapper = MultiWrapper(0x84BfCeFf9B6fdbC6862E08CcB8D685bc101Ff840);

        string[] memory _oracleNames = new string[](4);
        _oracleNames[0] = "SolidlyOracle";
        _oracleNames[1] = "UniswapV3LikeOracle";
        _oracleNames[2] = "UniswapV3LikeOracle";
        _oracleNames[3] = "UniswapV3LikeOracle";

        address[][] memory _addressParams = new address[][](4);
        _addressParams[0] = new address[](1);
        _addressParams[0][0] = 0x420DD381b31aEf6683db6B902084cB0FFECe40Da; // aerodrome factory
        _addressParams[1] = new address[](1);
        _addressParams[1][0] = 0x5e7BB104d84c7CB9B682AaC2F3d509f5F406809A; // legacy slipstream factory
        _addressParams[2] = new address[](1);
        _addressParams[2][0] = 0xaDe65c38CD4849aDBA595a4323a8C7DdfE89716a; // slipstream factory
        _addressParams[3] = new address[](1);
        _addressParams[3][0] = 0xf8f2eB4940CFE7d13603DDDD87f123820Fc061Ef; // new cl factory

        bytes32[] memory _bytesParams = new bytes32[](4);
        _bytesParams[0] = 0x6f178972b07752b522a4da1c5b71af6524e8b0bd6027ccb29e5312b0e5bcdc3c; //aerodrome init code hash
        //legacy slipstream init code hash
        _bytesParams[1] = keccak256(
            abi.encodePacked(
                hex"3d602d80600a3d3981f3363d3d373d3d3d363d73",
                0xeC8E5342B19977B4eF8892e02D8DAEcfa1315831,
                hex"5af43d82803e903d91602b57fd5bf3"
            )
        );
        //slipstream init code hash
        _bytesParams[2] = keccak256(
            abi.encodePacked(
                hex"3d602d80600a3d3981f3363d3d373d3d3d363d73",
                0x942e97a4c6FdC38B4CD1c0298D37d81fDD8E5A16,
                hex"5af43d82803e903d91602b57fd5bf3"
            )
        );
        //new cl factory init code hash
        _bytesParams[3] = keccak256(
            abi.encodePacked(
                hex"3d602d80600a3d3981f3363d3d373d3d3d363d73",
                0xc770898522D2A9c8Da7A10D63989b6b58305B665,
                hex"5af43d82803e903d91602b57fd5bf3"
            )
        );

        uint24[][] memory _uint24Params = new uint24[][](4);
        // legacy slipstream tickspacings
        _uint24Params[1] = new uint24[](6);
        _uint24Params[1][0] = 1;
        _uint24Params[1][1] = 10;
        _uint24Params[1][2] = 50;
        _uint24Params[1][3] = 100;
        _uint24Params[1][4] = 200;
        _uint24Params[1][5] = 2_000;

        // slipstream tickspacings
        _uint24Params[2] = new uint24[](7);
        _uint24Params[2][0] = 1;
        _uint24Params[2][1] = 10;
        _uint24Params[2][2] = 50;
        _uint24Params[2][3] = 100;
        _uint24Params[2][4] = 200;
        _uint24Params[2][5] = 500;
        _uint24Params[2][6] = 2_000;

        // new cl factory tickspacings
        _uint24Params[3] = new uint24[](7);
        _uint24Params[3][0] = 1;
        _uint24Params[3][1] = 10;
        _uint24Params[3][2] = 50;
        _uint24Params[3][3] = 100;
        _uint24Params[3][4] = 200;
        _uint24Params[3][5] = 500;
        _uint24Params[3][6] = 2_000;

        OffchainOracle.OracleType[] memory _oracleTypes = new OffchainOracle.OracleType[](4);
        _oracleTypes[0] = OffchainOracle.OracleType.WETH;
        _oracleTypes[1] = OffchainOracle.OracleType.WETH;
        _oracleTypes[2] = OffchainOracle.OracleType.WETH;
        _oracleTypes[3] = OffchainOracle.OracleType.WETH;

        IERC20[] memory _connectors = new IERC20[](4);
        _connectors[0] = IERC20(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF);
        _connectors[1] = IERC20(0x4200000000000000000000000000000000000006);
        _connectors[2] = IERC20(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913);
        _connectors[3] = IERC20(0x50c5725949A6F0c72E6C4a641F24049A917DB0Cb);

        params = Base.DeploymentParameters({
            owner: 0xBA4BB89f4d1E66AA86B60696534892aE0cCf91F5,
            chainName: "BASE",
            wrapperNames: new string[](0),
            wrapperParams: new address[][](0),
            oracleNames: _oracleNames,
            addressParams: _addressParams,
            bytesParams: _bytesParams,
            uint24Params: _uint24Params,
            oracleTypes: _oracleTypes,
            connectors: _connectors,
            wBase: IERC20(0x4200000000000000000000000000000000000006)
        });
    }
}
