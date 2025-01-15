// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "forge-std/Test.sol";
import "forge-std/console2.sol";

import "contracts/OffchainOracle.sol";
import "deploy/foundry/deployments/DeployOffchainOracleSoneium.s.sol";

contract OffchainOracleSoneiumTest is Test {
    DeployOffchainOracleSoneium public deploy;
    OffchainOracle public offchainOracle;
    MultiWrapper public multiWrapper;
    IOracle[] public oracles;

    function setUp() public {
        vm.createSelectFork("soneium", 1911329);
        deploy = new DeployOffchainOracleSoneium();
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
        IERC20 srcToken = IERC20(0x4200000000000000000000000000000000000006); //weth
        IERC20 dstToken = IERC20(0xbA9986D2381edf1DA03B0B9c1f8b00dc4AacC369); //usdc.e

        uint256 weightedRate = offchainOracle.getRate({srcToken: srcToken, dstToken: dstToken, useWrappers: false});

        assertEq(weightedRate, 3328954430);
    }
}
