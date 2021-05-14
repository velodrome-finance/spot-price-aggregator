/**
 *Submitted for verification at Etherscan.io on 2021-03-02
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;


contract GasEstimator {
    function gasLimit() external view returns (uint256) {
        return gasleft();
    }

    function gasCost(address target, bytes calldata data) external view returns(uint256 gasUsed, bool success) {
        uint256 gas = gasleft();
        (bool s, bytes memory m) = target.staticcall(data);
        m = m; // suppress unused warning
        return (gas - gasleft(), s);
    }
}
