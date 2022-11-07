// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract test2 {
    uint nombre;
    string phrase;
    address uneAddress;

    function getNombre() public view returns(uint) {
        return nombre;
    }

    function setNombre(uint _nombre) public {
        nombre = _nombre;
    }

    function getPhrase() public view returns(string memory) {
        return phrase;
    }

    function setPhrase(string memory _phrase) public {
        phrase = _phrase;
    }  

    function getAddress() public view returns(address) {
        return uneAddress;
    }

    function setAddress(address _address) public {
        uneAddress = _address;
    } 
}
