pragma solidity ^0.4.24;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

import "./LemonadeFactory.sol";

/// @title Ownership of lemonade
/// @author Jonathan Søyland-Lier
/// @notice Takes care of what's mine and what's yours
contract LemonadeOwnership is LemonadeFactory {

    using SafeMath for uint256;

    mapping (uint => address) lemonadeApprovals;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) internal operatorApprovals;

    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerLemonadeCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return lemonadeToOwner[_tokenId];
    }

    function exists(uint256 _tokenId) public view returns (bool _exists) {
        address owner = lemonadeToOwner[_tokenId];
        return owner != address(0);
    }


    //**************
    //Approve
    //************ */

    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        lemonadeApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function getApproved(uint256 _tokenId) public view returns (address _operator){
        return lemonadeApprovals[_tokenId];
    }

    function setApprovalForAll(address _to, bool _approved) public {
        require(_to != msg.sender);
        operatorApprovals[msg.sender][_to] = _approved;
        emit ApprovalForAll(msg.sender, _to, _approved);
    }

    function isApprovedForAll(address _owner, address _operator) public view returns (bool)
    {
        return operatorApprovals[_owner][_operator];
    }

    //**************
    //Transfer
    //************ */

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerLemonadeCount[_to] = ownerLemonadeCount[_to].add(1);
        ownerLemonadeCount[_from] = ownerLemonadeCount[_from].sub(1);
        lemonadeToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        _transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
        // solium-disable-next-line arg-overflow
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId)
    {
        transferFrom(_from, _to, _tokenId);
    }

    

    function takeOwnership(uint256 _tokenId) public {
        require(lemonadeApprovals[_tokenId] == msg.sender);
        address owner = ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }

}