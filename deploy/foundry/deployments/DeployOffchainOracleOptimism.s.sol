// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOffchainOracle.s.sol";

contract DeployOffchainOracleOptimism is DeployOffchainOracle {
    function setUp() public override {
        //setting Multiwrapper since there's no need to deploy it
        multiWrapper = MultiWrapper(0x61ee5f992181ecd1f8C5D8EcFd46a96b03b6251F);

        string[] memory _oracleNames = new string[](2);
        _oracleNames[0] = "SolidlyOracle";
        _oracleNames[1] = "UniswapV3LikeOracle";

        address[][] memory _addressParams = new address[][](2);
        _addressParams[0] = new address[](1);
        _addressParams[0][0] = 0xF1046053aa5682b4F9a81b5481394DA16BE5FF5a; //velodrome factory
        _addressParams[1] = new address[](1);
        _addressParams[1][0] = 0xCc0bDDB707055e04e497aB22a59c2aF4391cd12F; //slipstream factory

        bytes32[] memory _bytesParams = new bytes32[](2);
        _bytesParams[0] = 0xc0629f1c7daa09624e54d4f711ba99922a844907cce02997176399e4cc7e8fcf; //velodrome init code hash
        //slipstream init code hash
        _bytesParams[1] = keccak256(
            abi.encodePacked(
                hex"3d602d80600a3d3981f3363d3d373d3d3d363d73",
                0xc28aD28853A547556780BEBF7847628501A3bCbb,
                hex"5af43d82803e903d91602b57fd5bf3"
            )
        );

        uint24[][] memory _uint24Params = new uint24[][](2);
        _uint24Params[1] = new uint24[](5);
        _uint24Params[1][0] = 1;
        _uint24Params[1][1] = 50;
        _uint24Params[1][2] = 100;
        _uint24Params[1][3] = 200;
        _uint24Params[1][4] = 2_000;

        OffchainOracle.OracleType[] memory _oracleTypes = new OffchainOracle.OracleType[](2);
        _oracleTypes[0] = OffchainOracle.OracleType.WETH;
        _oracleTypes[1] = OffchainOracle.OracleType.WETH;

        IERC20[] memory _connectors = new IERC20[](9);
        _connectors[0] = IERC20(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF);
        _connectors[1] = IERC20(0x4200000000000000000000000000000000000006); //weth
        _connectors[2] = IERC20(0x7F5c764cBc14f9669B88837ca1490cCa17c31607); //usdc bridged
        _connectors[3] = IERC20(0x94b008aA00579c1307B0EF2c499aD98a8ce58e58); //usdt
        _connectors[4] = IERC20(0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1); //dai
        _connectors[5] = IERC20(0x0b2C639c533813f4Aa9D7837CAf62653d097Ff85); //usdc native
        _connectors[6] = IERC20(0x1F32b1c2345538c0c6f582fCB022739c4A194Ebb); // wstETH,
        _connectors[7] = IERC20(0x4200000000000000000000000000000000000042); // OP,
        _connectors[8] = IERC20(0x8c6f28f2F1A3C87F0f938b96d27520d9751ec8d9); // sUSD

        params = Base.DeploymentParameters({
            owner: 0xBA4BB89f4d1E66AA86B60696534892aE0cCf91F5,
            chainName: "OPTIMISM",
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
