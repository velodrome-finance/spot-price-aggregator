// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";
import "contracts/OffchainOracle.sol";
import "contracts/MultiWrapper.sol";

abstract contract Base is Script {
    using stdJson for string;

    string public chainName;

    address public deployerAddress = 0xd42C7914cF8dc24a1075E29C283C581bd1b0d3D3;

    function setUp() public virtual;

    function _getOffchainOracle() internal view returns (address) {
        return _getContractAddress("OffchainOracle");
    }

    function _getContractAddress(string memory contractName) internal view returns (address contractAddress) {
        string memory deploymentFilePath = string.concat(vm.projectRoot(), "/deployments/", chainName, ".json");
        string memory deploymentFile = vm.readFile(deploymentFilePath);
        string memory jsonKey = string.concat("...", contractName);
        contractAddress = abi.decode(vm.parseJson(deploymentFile, jsonKey), (address));
    }

    function _writeContractAddress(string memory contractName, address contractAddress) internal {
        string memory deploymentFilePath = string.concat(vm.projectRoot(), "/deployments/", chainName, ".json");
        string memory jsonObj = vm.serializeAddress("...", contractName, contractAddress);
        vm.writeJson(jsonObj, deploymentFilePath);
    }
}