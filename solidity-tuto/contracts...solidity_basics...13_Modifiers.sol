// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract test13 {
    address owner;
    uint nombre;

    constructor() {
        owner = msg.sender;
    }

    modifier isOwner() {
        require(msg.sender == owner, 'Not Owner');
        _;
    }
    
    function setNombre(uint _n) public isOwner {
        nombre = _n;
    }

    function getNombre() public view returns(uint){
        return nombre;
    }
}
