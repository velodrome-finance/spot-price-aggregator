// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOffchainOracle.s.sol";

contract DeployOffchainOracleOptimism is DeployOffchainOracle {
    address public constant OWNER = 0xBA4BB89f4d1E66AA86B60696534892aE0cCf91F5;

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
        IWrapper[] memory existingWrappers = new IWrapper[](2);
        existingWrappers[0] = IWrapper(0x0c8fc7a71C28c768FDC1f7d75835229beBEB1573);
        existingWrappers[1] = IWrapper(0x1A75DF59f464a70Cc8f7383983852FF72e5F5167);

        multiWrapperParams = MultiWrapperParams({existingWrappers: existingWrappers, owner: OWNER});

        deployMultiWrapper();
    }

    function _getOracles() internal {
        oracles = new IOracle[](2);
        oracles[0] = IOracle(0xD4eFb5998DFBDFB791182fb610D0061136E9DB50);

        oracleTypes = new OffchainOracle.OracleType[](2);
        oracleTypes[0] = OffchainOracle.OracleType.WETH;
        oracleTypes[1] = OffchainOracle.OracleType.WETH;

        address slipstreamFactory = 0xCc0bDDB707055e04e497aB22a59c2aF4391cd12F;
        address slipstreamPoolImplementation = 0xc28aD28853A547556780BEBF7847628501A3bCbb;

        bytes memory slipstreamBytecodeCreate2 = abi.encodePacked(
            hex"3d602d80600a3d3981f3363d3d373d3d3d363d73",
            slipstreamPoolImplementation,
            hex"5af43d82803e903d91602b57fd5bf3"
        );
        bytes32 slipstreamInitcodeHash = keccak256(slipstreamBytecodeCreate2);

        address[] memory addressParams = new address[](1);
        addressParams[0] = slipstreamFactory;

        uint24[] memory uint24Params = new uint24[](5);
        uint24Params[0] = 1;
        uint24Params[1] = 50;
        uint24Params[2] = 100;
        uint24Params[3] = 200;
        uint24Params[4] = 2_000;

        oracleParams = new OracleParams[](1);
        oracleParams[0] = OracleParams({
            oracleName: "UniswapV3LikeOracle",
            addressParams: addressParams,
            bytesParams: slipstreamInitcodeHash,
            uint24Params: uint24Params,
            oraclekind: OffchainOracle.OracleType.WETH
        });

        oracles[1] = deployOracle(oracleParams[0]);
    }

    function _getConnectors() internal {
        connectors = new IERC20[](9);

        connectors[0] = IERC20(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF);
        connectors[1] = IERC20(0x4200000000000000000000000000000000000006); //weth
        connectors[2] = IERC20(0x7F5c764cBc14f9669B88837ca1490cCa17c31607); //usdc bridged
        connectors[3] = IERC20(0x94b008aA00579c1307B0EF2c499aD98a8ce58e58); //usdt
        connectors[4] = IERC20(0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1); //dai
        connectors[5] = IERC20(0x0b2C639c533813f4Aa9D7837CAf62653d097Ff85); //usdc native
        connectors[6] = IERC20(0x1F32b1c2345538c0c6f582fCB022739c4A194Ebb); // wstETH,
        connectors[7] = IERC20(0x4200000000000000000000000000000000000042); // OP,
        connectors[8] = IERC20(0x8c6f28f2F1A3C87F0f938b96d27520d9751ec8d9); // sUSD
    }
}
