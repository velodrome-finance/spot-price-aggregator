# Description of Foundry Deploy Scripts

This directory houses a suite of scripts designed for the deployment and administration of oracles. Each script's purpose and application are detailed below. Those residing in the `use-create3` directory specifically leverage the CREATE3 method for deployment. Prior to running these scripts, ensure they are properly configured by populating the `PARAMS` constant with the appropriate data.

```
.
├── deployOracleAndAdd
├── deployWrapperAndAdd
└── redeployOffchainOracle
```

### Scripts:

**1. `deployOracleAndAdd`**
- This script deploys an Oracle and subsequently adds it to OffchainOracle.

**2. `deployWrapperAndAdd`**
- This script deploys a Wrapper and subsequently adds it to MultiWrapper.

**3. `redeployOffchainOracle`**
- This script is specifically for deploying OffchainOracle with the parameters from the already deployed OffchainOracle and the current implementation in the repository.

For a complete deployment, the scripts can be used together (ex.: see deploy/foundry/deployments/* for OffchainOracle deployments).

## Usage

To use any of the scripts:
1. Set the parameters struct value in the script file:

2. Set the environment variables (for instance, in the `.env` file):
   ```
   CHAIN_NAME=network name
   <CHAIN_NAME>_RPC_URL=node RPC URL
   <CHAIN_NAME>_PRIVATE_KEY=deployer's private key
   <CHAIN_NAME>_ETHERSCAN_KEY=explorer key for verifying contract source code
   ```
3. Run script:
   ```
   forge script deploy/foundry/<path_to_script> --via-ir --rpc-url $<CHAIN_NAME>_RPC_URL --broadcast --verify 
   ```
