pragma solidity ^0.4.24;

import "./LemonadeSale.sol";

/// @title A Lemonade stand
/// @author Jonathan Søyland-Lier
/// @notice To sell the lemonade we make
contract LemonadeStand is LemonadeSale {

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
}