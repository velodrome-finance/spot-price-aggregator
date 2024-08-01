// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";
import "contracts/OffchainOracle.sol";
import "contracts/MultiWrapper.sol";

abstract contract Base is Script {
    using stdJson for string;

    string public chainName = vm.envString("CHAIN_NAME");

    uint256 public deployPrivateKey = vm.envUint(string.concat(chainName, "_", "PRIVATE_KEY"));
    address public deployerAddress = vm.rememberKey(deployPrivateKey);

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
