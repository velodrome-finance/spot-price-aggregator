// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOffchainOracle.s.sol";

contract DeployOffchainOracleSoneium is DeployOffchainOracle {
    function setUp() public override {
        string[] memory _oracleNames = new string[](2);
        _oracleNames[0] = "SolidlyOracle";
        _oracleNames[1] = "UniswapV3LikeOracle";

        address[][] memory _addressParams = new address[][](2);
        _addressParams[0] = new address[](1);
        _addressParams[0][0] = 0x31832f2a97Fd20664D76Cc421207669b55CE4BC0; //velodrome factory
        _addressParams[1] = new address[](1);
        _addressParams[1][0] = 0x04625B046C69577EfC40e6c0Bb83CDBAfab5a55F; //slipstream factory

        bytes32[] memory _bytesParams = new bytes32[](2);
        //velodrome init code hash
        _bytesParams[0] = keccak256(
            abi.encodePacked(
                hex"3d602d80600a3d3981f3363d3d373d3d3d363d73",
                0x10499d88Bd32AF443Fc936F67DE32bE1c8Bb374C, // pool implementation address (from factory)
                hex"5af43d82803e903d91602b57fd5bf3"
            )
        );
        //slipstream init code hash
        _bytesParams[1] = keccak256(
            abi.encodePacked(
                hex"3d602d80600a3d3981f3363d3d373d3d3d363d73",
                0x321f7Dfb9B2eA9131B8C17691CF6e01E5c149cA8, // pool implementation address (from factory)
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

        IERC20[] memory _connectors = new IERC20[](4);
        _connectors[0] = IERC20(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF); // NONE
        _connectors[1] = IERC20(0xbA9986D2381edf1DA03B0B9c1f8b00dc4AacC369); // USDC.e
        _connectors[2] = IERC20(0x4200000000000000000000000000000000000006); //WETH
        _connectors[3] = IERC20(0x7f9AdFbd38b669F03d1d11000Bc76b9AaEA28A81); //XVELO

        params = Base.DeploymentParameters({
            owner: 0x3B39854f29D7Ec7110afe806312E1d9893F00C83,
            chainName: "SONEIUM",
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
