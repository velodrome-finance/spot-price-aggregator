// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.20 <0.9.0;

import "deploy/foundry/utils/Base.s.sol";
import "contracts/oracles/ChainlinkOracle.sol";
import "contracts/oracles/DodoOracle.sol";
import "contracts/oracles/DodoV2Oracle.sol";
import "contracts/oracles/KlaySwapOracle.sol";
import "contracts/oracles/KyberDmmOracle.sol";
import "contracts/oracles/MooniswapOracle.sol";
import "contracts/oracles/SolidlyOracle.sol";
import "contracts/oracles/SolidlyOracleNoCreate2.sol";
import "contracts/oracles/SyncswapOracle.sol";
import "contracts/oracles/SynthetixOracle.sol";
import "contracts/oracles/UniswapOracle.sol";
import "contracts/oracles/UniswapV2LikeOracle.sol";
import "contracts/oracles/UniswapV3LikeOracle.sol";

contract DeployOracle is Base {
    enum OracleEnum {
        ChainlinkOracle,
        DodoOracle,
        DodoV2Oracle,
        KlaySwapOracle,
        KyberDmmOracle,
        MooniswapOracle,
        SolidlyOracle,
        SolidlyOracleNoCreate2,
        SyncswapOracle,
        SynthetixOracle,
        UniswapOracle,
        UniswapV2LikeOracle,
        UniswapV3LikeOracle
    }

    struct OracleParams {
        string oracleName;
        address[] addressParams;
        bytes32 bytesParams;
        uint24[] uint24Params;
        OffchainOracle.OracleType oraclekind;
    }

    mapping(string => OracleEnum) public stringToOracleEnum;

    OracleParams[] public oracleParams;

    IOracle[] public oracles;
    OffchainOracle.OracleType[] public oracleTypes;

    function deployOracles() internal {
        _setOracleMapping();

        oracles = new IOracle[](oracleParams.length);
        oracleTypes = new OffchainOracle.OracleType[](oracleParams.length);
        for (uint256 i = 0; i < oracleParams.length; i++) {
            oracles[i] = deployOracle(oracleParams[i]);
            oracleTypes[i] = oracleParams[i].oraclekind;
        }
    }

    function deployOracle(OracleParams memory _oracleParams) internal returns (IOracle oracle) {
        _setOracleMapping();
        string memory oracleName = _oracleParams.oracleName;

        if (stringToOracleEnum[oracleName] == OracleEnum.ChainlinkOracle) {
            oracle = IOracle(new ChainlinkOracle(IChainlink(_oracleParams.addressParams[0])));
        } else if (stringToOracleEnum[oracleName] == OracleEnum.DodoOracle) {
            oracle = IOracle(new DodoOracle(IDodoZoo(_oracleParams.addressParams[0])));
        } else if (stringToOracleEnum[oracleName] == OracleEnum.DodoV2Oracle) {
            oracle = IOracle(new DodoV2Oracle(IDVMFactory(_oracleParams.addressParams[0])));
        } else if (stringToOracleEnum[oracleName] == OracleEnum.KlaySwapOracle) {
            oracle = IOracle(
                new KlaySwapOracle(
                    IKlaySwapFactory(_oracleParams.addressParams[0]), IKlaySwapStorage(_oracleParams.addressParams[1])
                )
            );
        } else if (stringToOracleEnum[oracleName] == OracleEnum.KyberDmmOracle) {
            oracle = IOracle(new KyberDmmOracle(IKyberDmmFactory(_oracleParams.addressParams[0])));
        } else if (stringToOracleEnum[oracleName] == OracleEnum.MooniswapOracle) {
            oracle = IOracle(new MooniswapOracle(IMooniswapFactory(_oracleParams.addressParams[0])));
        } else if (stringToOracleEnum[oracleName] == OracleEnum.SolidlyOracle) {
            oracle = IOracle(new SolidlyOracle(_oracleParams.addressParams[0], _oracleParams.bytesParams));
        } else if (stringToOracleEnum[oracleName] == OracleEnum.SolidlyOracleNoCreate2) {
            oracle = IOracle(new SolidlyOracleNoCreate2(ISolidlyFactory(_oracleParams.addressParams[0])));
        } else if (stringToOracleEnum[oracleName] == OracleEnum.SyncswapOracle) {
            oracle = IOracle(new SyncswapOracle(ISyncswapFactory(_oracleParams.addressParams[0])));
        } else if (stringToOracleEnum[oracleName] == OracleEnum.SynthetixOracle) {
            oracle = IOracle(new SynthetixOracle(ISynthetixProxy(_oracleParams.addressParams[0])));
        } else if (stringToOracleEnum[oracleName] == OracleEnum.UniswapOracle) {
            oracle = IOracle(new UniswapOracle(IUniswapFactory(_oracleParams.addressParams[0])));
        } else if (stringToOracleEnum[oracleName] == OracleEnum.UniswapV2LikeOracle) {
            oracle = IOracle(new UniswapV2LikeOracle(_oracleParams.addressParams[0], _oracleParams.bytesParams));
        } else if (stringToOracleEnum[oracleName] == OracleEnum.UniswapV3LikeOracle) {
            oracle = IOracle(
                new UniswapV3LikeOracle(
                    _oracleParams.addressParams[0], _oracleParams.bytesParams, _oracleParams.uint24Params
                )
            );
        }
        _writeContractAddress(_oracleParams.oracleName, address(oracle));

        if (address(oracle) == address(0)) {
            revert("Oracle name not found.");
        }
    }

    function _setOracleMapping() private {
        stringToOracleEnum["ChainlinkOracle"] = OracleEnum.ChainlinkOracle;
        stringToOracleEnum["DodoOracle"] = OracleEnum.DodoOracle;
        stringToOracleEnum["DodoV2Oracle"] = OracleEnum.DodoV2Oracle;
        stringToOracleEnum["KlaySwapOracle"] = OracleEnum.KlaySwapOracle;
        stringToOracleEnum["KyberDmmOracle"] = OracleEnum.KyberDmmOracle;
        stringToOracleEnum["MooniswapOracle"] = OracleEnum.MooniswapOracle;
        stringToOracleEnum["SolidlyOracle"] = OracleEnum.SolidlyOracle;
        stringToOracleEnum["SolidlyOracleNoCreate2"] = OracleEnum.SolidlyOracleNoCreate2;
        stringToOracleEnum["SyncswapOracle"] = OracleEnum.SyncswapOracle;
        stringToOracleEnum["SynthetixOracle"] = OracleEnum.SynthetixOracle;
        stringToOracleEnum["UniswapOracle"] = OracleEnum.UniswapOracle;
        stringToOracleEnum["UniswapV2LikeOracle"] = OracleEnum.UniswapV2LikeOracle;
        stringToOracleEnum["UniswapV3LikeOracle"] = OracleEnum.UniswapV3LikeOracle;
    }
}
