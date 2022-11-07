// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import './14_Extends.sol';

contract LandlordHouses is Owner {
    enum typeOf {house, flat, land}

    uint counter;

    struct House {
        uint id;
        string name;
        uint price;
        typeOf _typeOf;
    }

    mapping(address => House[]) Houses;

    function addHouse(address _landlord, string memory _name, uint _price, typeOf _typeOf) public isOwner {
        require(_price > 1000, 'Price > 1000 WEI');
        require(uint(_typeOf) >= 0, 'Type entre 0 et 2');
        require(uint(_typeOf) <= 0, 'Type entre 0 et 2');
        counter++;
        Houses[_landlord].push(House(counter, _name, _price, _typeOf));
    }

    function getHouses(address _landlord) public view isOwner returns(House[] memory) {
        return Houses[_landlord];
    }

    function nbHouses(address _landlord) public view isOwner returns(uint) {
        return Houses[_landlord].length;
    }

    function getMyHouses() public view returns(House[] memory) {
        return Houses[msg.sender];
    }
}
