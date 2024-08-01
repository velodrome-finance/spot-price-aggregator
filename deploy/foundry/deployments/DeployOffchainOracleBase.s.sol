// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOffchainOracle.s.sol";

contract DeployOffchainOracleBase is DeployOffchainOracle {
    address public constant OWNER = 0xE6A41fE61E7a1996B59d508661e3f524d6A32075;

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
        multiWrapper = MultiWrapper(0x84BfCeFf9B6fdbC6862E08CcB8D685bc101Ff840);
    }

    function _getOracles() internal {
        oracles = new IOracle[](2);
        oracles[0] = IOracle(0xedAEc518e432F4627F23f0a069fd43a4051161C6);
        oracles[1] = IOracle(0x7d57F783A9B8f1Ac1605ff291c8556C592b4bF78);

        oracleTypes = new OffchainOracle.OracleType[](2);
        oracleTypes[0] = OffchainOracle.OracleType.WETH;
        oracleTypes[1] = OffchainOracle.OracleType.WETH;
    }

    function _getConnectors() internal {
        connectors = new IERC20[](4);

        connectors[0] = IERC20(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF);
        connectors[1] = IERC20(0x4200000000000000000000000000000000000006);
        connectors[2] = IERC20(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913);
        connectors[3] = IERC20(0x50c5725949A6F0c72E6C4a641F24049A917DB0Cb);
    }
}
