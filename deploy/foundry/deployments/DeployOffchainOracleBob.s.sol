// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOffchainOracle.s.sol";

contract DeployOffchainOracleBob is DeployOffchainOracle {
    function setUp() public override {
        string[] memory wrapperNames = new string[](2);
        wrapperNames[0] = "CompoundLikeWrapper";
        wrapperNames[1] = "CompoundLikeWrapper";

        address[][] memory wrapperParams = new address[][](2);
        wrapperParams[0] = new address[](2);
        wrapperParams[0][0] = 0x9f53Cd350c3aC49cE6CE673abff647E5fe79A3CC;
        wrapperParams[0][1] = 0xb4255533Ad74A25A83d17154cB48A287E8f6A811;
        wrapperParams[1] = new address[](2);
        wrapperParams[1][0] = 0x77cabFd057Bd7C81c011059F1bf74eC1fBeDa971;
        wrapperParams[1][1] = 0xbd00E7923775C781D1BF0cAE4e0de8EFe8B60ccB;

        string[] memory _oracleNames = new string[](1);
        _oracleNames[0] = "SolidlyOracle";

        address[][] memory _addressParams = new address[][](1);
        _addressParams[0] = new address[](1);
        _addressParams[0][0] = 0x31832f2a97Fd20664D76Cc421207669b55CE4BC0; //velodrome factory

        bytes32[] memory _bytesParams = new bytes32[](1);
        //velodrome init code hash
        _bytesParams[0] = keccak256(
            abi.encodePacked(
                hex"3d602d80600a3d3981f3363d3d373d3d3d363d73",
                0x10499d88Bd32AF443Fc936F67DE32bE1c8Bb374C, // pool implementation address (from factory)
                hex"5af43d82803e903d91602b57fd5bf3"
            )
        );

        OffchainOracle.OracleType[] memory _oracleTypes = new OffchainOracle.OracleType[](1);
        _oracleTypes[0] = OffchainOracle.OracleType.WETH;

        IERC20[] memory _connectors = new IERC20[](5);
        _connectors[0] = IERC20(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF);
        _connectors[1] = IERC20(0x4200000000000000000000000000000000000006); //weth
        _connectors[2] = IERC20(0xe75D0fB2C24A55cA1e3F96781a2bCC7bdba058F0); //usdc bridged
        _connectors[3] = IERC20(0x05D032ac25d322df992303dCa074EE7392C117b9); //usdt
        _connectors[4] = IERC20(0x03C7054BCB39f7b2e5B2c7AcB37583e32D70Cfa3); //wbtc

        params = Base.DeploymentParameters({
            owner: 0x607EbA808EF2685fAc3da68aB96De961fa8F3312,
            chainName: "BOB",
            wrapperNames: wrapperNames,
            wrapperParams: wrapperParams,
            oracleNames: _oracleNames,
            addressParams: _addressParams,
            bytesParams: _bytesParams,
            uint24Params: new uint24[][](1),
            oracleTypes: _oracleTypes,
            connectors: _connectors,
            wBase: IERC20(0x4200000000000000000000000000000000000006)
        });
    }
}
