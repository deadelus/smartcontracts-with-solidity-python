// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 <  0.9.0;

contract SimpleStorage {

    uint256 public favoriteNumber = 5;
    int256 favoriteInt = -5;
    bool favoriteBool = false;
    string favoriteString = "Hello";
    address favoriteAddress = 0xa34e9c2Ad2de0a98397F7154f45e91eAc6f8B74E;
    bytes32 favoriteBytes = "Toto";

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    People public person = People({favoriteNumber: 2, name: "Patrick"});
    People[] public people;
    // A key val map 
    mapping(string => uint256) public nameToFavNumber;

    function store(uint256 _favoriteNumber) public  {
        favoriteNumber = _favoriteNumber;
    }

    // view, pure are RO - non state changing
    // pure is just for Math purpose
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }
    function additionFunc(int256 number) public pure {
        number + number;
    }

    // memory only store data for execution of the function or contract
    // storage keyword the data can be processed after the execution
    function addPerson(string memory _name, uint256 _nb) public {
        people.push(People(_nb,_name));
        nameToFavNumber[_name] = _nb;
    }
}