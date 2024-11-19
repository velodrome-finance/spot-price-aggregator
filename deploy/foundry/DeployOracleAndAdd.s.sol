// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/DeployOracle.s.sol";

abstract contract DeployOracleAndAdd is DeployOracle {
    function _setOraclesParams() internal returns (OracleParams[] memory) {
        // oracleParams = new OracleParams[](1);
        // oracleParams[0] = OracleParams({
        //     oracleName: "SolidlyOracle",
        //     addressParams: [velodromeFactory],
        //     bytesParams: [velodromeInitcodeHash],
        //     uint24Params: new uint24[](0),
        //     oraclekind: OffchainOracle.OracleType.WETH
        // });
    }

    function run() public {
        OffchainOracle offchainOracle = OffchainOracle(_getOffchainOracle());

        _setOraclesParams();
        deployOracles();

        for (uint256 i = 0; i < oracles.length; i++) {
            offchainOracle.addOracle(oracles[i], oracleParams[i].oraclekind);
        }
    }
}
