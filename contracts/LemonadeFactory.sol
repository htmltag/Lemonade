pragma solidity ^0.4.24;

import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

import "./LemonadeCoin.sol";

/// @title A contract to make Lemonade
/// @author Jonathan Søyland-Lier
/// @notice Makes lemonade by simple recipe
contract LemonadeFactory is LemonadeCoin, Ownable {

    using SafeMath for uint256; 

    event NewLemonade(uint lemonadeId, string name, uint8 ingredients);

    modifier onlyOwnerOf(uint256 _lemonadeId) {
        require(msg.sender == lemonadeToOwner[_lemonadeId]);
        _;
    }

    struct Lemonade {
        string name;
        uint8 ingredients; //ingredient is a number from 0 to 199. Eks: 198 - 1 is water, 9 is sugar and 8 is lemon
        bool consumed;
        uint256 coin;
    }

    Lemonade[] public lemonades;

    mapping (uint => address) public lemonadeToOwner;
    mapping (address => uint) ownerLemonadeCount;

    /**
    * Private - Internals
    */

    function _createLemonade(string _name, uint8 _ingredients) internal {
        uint256 _coin = _createCoin(_name, msg.sender);
        Lemonade memory lemonade = Lemonade({
            name: _name,
            ingredients: _ingredients,
            consumed: false,
            coin: _coin
        });
        uint256 id = lemonades.push(lemonade) - 1;
        lemonadeToOwner[id] = msg.sender;
        ownerLemonadeCount[msg.sender] = ownerLemonadeCount[msg.sender].add(1);
        emit NewLemonade(id, _name, _ingredients);
    }

    /**
    * Externals
    */

    ///@notice Creates new Lemonade and mint a coin with it
    function createLemonade(string _name, uint8 _ingredients) external {
        require(_ingredients <= 199);  
        _createLemonade(_name, _ingredients);
    }

    ///@notice Owner consumes the lemonade and we burn the coin
    function consumeLemonade(uint256 _lemonadeId) external {
        require(lemonadeToOwner[_lemonadeId] == msg.sender);
        lemonades[_lemonadeId].consumed = true;
        _burnCoin(msg.sender, lemonades[_lemonadeId].coin);
        ownerLemonadeCount[msg.sender] = ownerLemonadeCount[msg.sender].sub(1);
    }

    /**
    * Public
    */

    function getLemonadeCoin(uint256 _lemonadeId) public view returns(uint256) {
        return lemonades[_lemonadeId].coin;
    }

    function getLemonadeIngredients(uint256 _lemonadeId) public view returns(uint256) {
        return lemonades[_lemonadeId].ingredients;
    }

}