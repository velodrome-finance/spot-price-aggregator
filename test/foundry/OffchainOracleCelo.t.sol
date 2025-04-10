// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "forge-std/Test.sol";
import "forge-std/console2.sol";

import "contracts/OffchainOracle.sol";
import "deploy/foundry/deployments/DeployOffchainOracleCelo.s.sol";

contract OffchainOracleCeloTest is Test {
    DeployOffchainOracleCelo public deploy;
    OffchainOracle public offchainOracle;
    MultiWrapper public multiWrapper;
    IOracle[] public oracles;

    function setUp() public {
        vm.createSelectFork("celo", 32372053);
        deploy = new DeployOffchainOracleCelo();
        deploy.setUp();
        deploy.run();

        offchainOracle = deploy.offchainOracle();
        multiWrapper = deploy.multiWrapper();
        oracles = new IOracle[](2);
        oracles[0] = deploy.oracles(0);
        oracles[1] = deploy.oracles(1);
    }

    function testDeploy() public view {
        assertNotEq(address(offchainOracle), address(0));
        assertNotEq(address(multiWrapper), address(0));
        assertNotEq(address(oracles[0]), address(0));
        assertNotEq(address(oracles[1]), address(0));
    }

    function testGetRate() public view {
        IERC20 srcToken = IERC20(0xD221812de1BD094f35587EE8E174B07B6167D9Af); //weth
        IERC20 dstToken = IERC20(0x48065fbBE25f71C9282ddf5e1cD6D6A887483D5e); //usdt

        uint256 weightedRate = offchainOracle.getRate({srcToken: srcToken, dstToken: dstToken, useWrappers: false});

        assertEq(weightedRate, 1597192269);
    }
}
