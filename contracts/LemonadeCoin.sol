pragma solidity ^0.4.24;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract LemonadeCoin is ERC721Token("LemonadeCoin", "LMC") {

    mapping(uint256 => string) internal coinIdToName;
    mapping(string => uint256) internal nameToCoinId;

    function _createCoin(string _name, address _to) internal returns(uint256) {
        require(nameToCoinId[_name] == 0);
        uint256 coinId = allTokens.length + 1;
        _mint(_to, coinId);
        coinIdToName[coinId] = _name;
        nameToCoinId[_name] = coinId;
        return coinId;
    }

    function _burnCoin(address _owner, uint256 _coinId) internal {
        _burn(_owner, _coinId);
    }

    function getCoinName(uint256 _coinId) view public returns (string) {
        return coinIdToName[_coinId];
    }

    function getCoinId(string _name) view public returns (uint) {
        return nameToCoinId[_name];
    }

}