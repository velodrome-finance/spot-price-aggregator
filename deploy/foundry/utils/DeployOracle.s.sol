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

abstract contract DeployOracle is Base {
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

    mapping(string => OracleEnum) private _stringToOracleEnum;

    IOracle[] public oracles;

    function _deployOracles() internal {
        _setOracleMapping();

        uint256 length = params.oracleNames.length;
        oracles = new IOracle[](length);
        for (uint256 i = 0; i < length; i++) {
            oracles[i] = _deployOracle(
                params.oracleNames[i], params.addressParams[i], params.bytesParams[i], params.uint24Params[i]
            );
        }
    }

    function _deployOracle(
        string memory _oracleName,
        address[] memory _addressParams,
        bytes32 _bytesParams,
        uint24[] memory _uint24Params
    ) private returns (IOracle oracle) {
        _setOracleMapping();

        if (_stringToOracleEnum[_oracleName] == OracleEnum.ChainlinkOracle) {
            oracle = IOracle(new ChainlinkOracle(IChainlink(_addressParams[0])));
        } else if (_stringToOracleEnum[_oracleName] == OracleEnum.DodoOracle) {
            oracle = IOracle(new DodoOracle(IDodoZoo(_addressParams[0])));
        } else if (_stringToOracleEnum[_oracleName] == OracleEnum.DodoV2Oracle) {
            oracle = IOracle(new DodoV2Oracle(IDVMFactory(_addressParams[0])));
        } else if (_stringToOracleEnum[_oracleName] == OracleEnum.KlaySwapOracle) {
            oracle =
                IOracle(new KlaySwapOracle(IKlaySwapFactory(_addressParams[0]), IKlaySwapStorage(_addressParams[1])));
        } else if (_stringToOracleEnum[_oracleName] == OracleEnum.KyberDmmOracle) {
            oracle = IOracle(new KyberDmmOracle(IKyberDmmFactory(_addressParams[0])));
        } else if (_stringToOracleEnum[_oracleName] == OracleEnum.MooniswapOracle) {
            oracle = IOracle(new MooniswapOracle(IMooniswapFactory(_addressParams[0])));
        } else if (_stringToOracleEnum[_oracleName] == OracleEnum.SolidlyOracle) {
            oracle = IOracle(new SolidlyOracle(_addressParams[0], _bytesParams));
        } else if (_stringToOracleEnum[_oracleName] == OracleEnum.SolidlyOracleNoCreate2) {
            oracle = IOracle(new SolidlyOracleNoCreate2(ISolidlyFactory(_addressParams[0])));
        } else if (_stringToOracleEnum[_oracleName] == OracleEnum.SyncswapOracle) {
            oracle = IOracle(new SyncswapOracle(ISyncswapFactory(_addressParams[0])));
        } else if (_stringToOracleEnum[_oracleName] == OracleEnum.SynthetixOracle) {
            oracle = IOracle(new SynthetixOracle(ISynthetixProxy(_addressParams[0])));
        } else if (_stringToOracleEnum[_oracleName] == OracleEnum.UniswapOracle) {
            oracle = IOracle(new UniswapOracle(IUniswapFactory(_addressParams[0])));
        } else if (_stringToOracleEnum[_oracleName] == OracleEnum.UniswapV2LikeOracle) {
            oracle = IOracle(new UniswapV2LikeOracle(_addressParams[0], _bytesParams));
        } else if (_stringToOracleEnum[_oracleName] == OracleEnum.UniswapV3LikeOracle) {
            oracle = IOracle(new UniswapV3LikeOracle(_addressParams[0], _bytesParams, _uint24Params));
        }
        _writeContractAddress(_oracleName, address(oracle));

        if (address(oracle) == address(0)) {
            revert("Oracle name not found.");
        }
    }

    function _setOracleMapping() private {
        _stringToOracleEnum["ChainlinkOracle"] = OracleEnum.ChainlinkOracle;
        _stringToOracleEnum["DodoOracle"] = OracleEnum.DodoOracle;
        _stringToOracleEnum["DodoV2Oracle"] = OracleEnum.DodoV2Oracle;
        _stringToOracleEnum["KlaySwapOracle"] = OracleEnum.KlaySwapOracle;
        _stringToOracleEnum["KyberDmmOracle"] = OracleEnum.KyberDmmOracle;
        _stringToOracleEnum["MooniswapOracle"] = OracleEnum.MooniswapOracle;
        _stringToOracleEnum["SolidlyOracle"] = OracleEnum.SolidlyOracle;
        _stringToOracleEnum["SolidlyOracleNoCreate2"] = OracleEnum.SolidlyOracleNoCreate2;
        _stringToOracleEnum["SyncswapOracle"] = OracleEnum.SyncswapOracle;
        _stringToOracleEnum["SynthetixOracle"] = OracleEnum.SynthetixOracle;
        _stringToOracleEnum["UniswapOracle"] = OracleEnum.UniswapOracle;
        _stringToOracleEnum["UniswapV2LikeOracle"] = OracleEnum.UniswapV2LikeOracle;
        _stringToOracleEnum["UniswapV3LikeOracle"] = OracleEnum.UniswapV3LikeOracle;
    }
}
