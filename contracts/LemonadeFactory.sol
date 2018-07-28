pragma solidity ^0.4.24;

import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

/// @title A contract to make Lemonade
/// @author Jonathan Søyland-Lier
/// @notice Makes lemonade by simple recipe
contract LemonadeFactory is ERC721Token("LemonadeCoin", "LMC"), Ownable {

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
    }

    Lemonade[] public lemonades;

    mapping (uint256 => address) public lemonadeToOwner;
    mapping (address => uint256) ownerLemonadeCount;

    /**
    * Private - Internals
    */
    
    function _createLemonade(string _name, uint8 _ingredients) internal {
        Lemonade memory lemonade = Lemonade({
            name: _name,
            ingredients: _ingredients,
            consumed: false
        });
        uint256 _lemonadeId = lemonades.push(lemonade) - 1;
        lemonadeToOwner[_lemonadeId] = msg.sender;
        ownerLemonadeCount[msg.sender] = ownerLemonadeCount[msg.sender].add(1);
        _mint(msg.sender, _lemonadeId);
        emit NewLemonade(_lemonadeId, _name, _ingredients);
    }

    /**
    * Externals
    */
    ///@notice Owner consumes the lemonade and we burn the coin
    function consumeLemonade(uint256 _lemonadeId, address _owner) external payable {
        require(lemonadeToOwner[_lemonadeId] == _owner);
        lemonades[_lemonadeId].consumed = true;
        _burn(_owner, _lemonadeId);
        ownerLemonadeCount[_owner] = ownerLemonadeCount[_owner].sub(1);
    }

    function getLemonadesByOwner(address _owner) external view returns(uint[]) {
        uint[] memory result = new uint[](ownerLemonadeCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < lemonades.length; i++) {
            if (lemonadeToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function size() external view returns (uint256) {
        return lemonades.length;
    }   

    /**
    * Public
    */

    ///@notice Creates new Lemonade and mint a coin with it
    function createLemonade(string _name, uint8 _ingredients) public payable {
        require(_ingredients <= 199);  
        _createLemonade(_name, _ingredients);
    }

    function getLemonadeIngredients(uint256 _lemonadeId) public view returns(uint8) {
        return lemonades[_lemonadeId].ingredients;
    }

}