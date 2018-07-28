pragma solidity ^0.4.24;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

import "./LemonadeFactory.sol";

contract LemonadeSale is LemonadeFactory {

    mapping (uint256 => Sale) lemonadeIdToSale;

    event SaleCreated(uint256 lemonadeId, uint256 price);
    event SaleSuccessful(uint256 lemonadeId, uint256 price, address buyer);
    event SaleCancelled(uint256 lemonadeId);

    struct Sale {
        address seller;
        uint256 price;
        bool exists;
    }

    //Set lemonade for sale
    function createSale(uint256 _lemonadeId, uint256 _price) public payable onlyOwnerOf(_lemonadeId) {
        Sale memory sale = Sale({
            seller: msg.sender,
            price: _price,
            exists: true
        });
        lemonadeIdToSale[_lemonadeId] = sale;
        emit SaleCreated(_lemonadeId, _price);
    }

    //Withdraw sale
    function cancelSale(uint256 _lemonadeId) public payable {
        require(lemonadeIdToSale[_lemonadeId].seller == msg.sender);
        _removeSale(_lemonadeId);
        emit SaleCancelled(_lemonadeId);
    }

    //clean up - remove the sale
    function _removeSale(uint256 _lemonadeId) internal {
        delete lemonadeIdToSale[_lemonadeId];
    }

    //
    function buy(uint256 _lemonadeId) public payable {
        Sale storage sale = lemonadeIdToSale[_lemonadeId];
        require(msg.value >= sale.price);

        address seller = sale.seller;
        uint256 price = sale.price;

        _removeSale(_lemonadeId);

        seller.transfer(price);
        lemonadeToOwner[_lemonadeId] = msg.sender;
        ownerLemonadeCount[seller] = ownerLemonadeCount[seller].sub(1);
        ownerLemonadeCount[msg.sender] = ownerLemonadeCount[msg.sender].add(1); 

        emit SaleSuccessful(_lemonadeId, price, msg.sender);
    }

    function forSale(uint256 _lemonadeId) external view returns(bool) {
        if(lemonadeIdToSale[_lemonadeId].exists == true){
            return true;
        }
        return false;
    }  

}