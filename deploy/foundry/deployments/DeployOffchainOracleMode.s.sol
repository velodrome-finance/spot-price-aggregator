// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOffchainOracle.s.sol";

contract DeployOffchainOracleMode is DeployOffchainOracle {
    function setUp() public override {
        string[] memory wrapperNames = new string[](2);
        wrapperNames[0] = "CompoundLikeWrapper";
        wrapperNames[1] = "CompoundLikeWrapper";

        address[][] memory wrapperParams = new address[][](2);
        //ionic
        wrapperParams[0] = new address[](2);
        wrapperParams[0][0] = 0xFB3323E24743Caf4ADD0fDCCFB268565c0685556;
        wrapperParams[0][1] = 0x71ef7EDa2Be775E5A7aa8afD02C45F059833e9d2;
        //layerbank
        wrapperParams[1] = new address[](2);
        wrapperParams[1][0] = 0x80980869D90A737aff47aBA6FbaA923012C1FF50;
        wrapperParams[1][1] = 0xe855B8018C22A05F84724e93693caf166912aDD5;

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

        IERC20[] memory _connectors = new IERC20[](5);
        _connectors[0] = IERC20(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF); //NONE
        _connectors[1] = IERC20(0x4200000000000000000000000000000000000006); //weth
        _connectors[2] = IERC20(0xDfc7C877a950e49D2610114102175A06C2e3167a); //mode
        _connectors[3] = IERC20(0xd988097fb8612cc24eeC14542bC03424c656005f); //usdc
        _connectors[4] = IERC20(0xf0F161fDA2712DB8b566946122a5af183995e2eD); //usdt

        params = Base.DeploymentParameters({
            owner: 0xe915AEf46E1bd9b9eD2D9FE571AE9b5afbDE571b,
            chainName: "MODE",
            wrapperNames: wrapperNames,
            wrapperParams: wrapperParams,
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
