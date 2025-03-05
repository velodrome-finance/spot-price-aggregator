// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "forge-std/Test.sol";
import "forge-std/console2.sol";

import "contracts/OffchainOracle.sol";
import "deploy/foundry/deployments/DeployOffchainOracleSwell.s.sol";

contract OffchainOracleSwellTest is Test {
    DeployOffchainOracleSwell public deploy;
    OffchainOracle public offchainOracle;
    MultiWrapper public multiWrapper;
    IOracle[] public oracles;

    function setUp() public {
        vm.createSelectFork("swell", 4241087);
        deploy = new DeployOffchainOracleSwell();
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
        IERC20 dstToken = IERC20(0x7f9AdFbd38b669F03d1d11000Bc76b9AaEA28A81); //xvelo

        uint256 weightedRate = offchainOracle.getRate({srcToken: srcToken, dstToken: dstToken, useWrappers: false});

        assertEq(weightedRate, 36598523566779443059762);
    }
}
