// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract Owner {
    address owner;
    
    constructor() {
        owner = msg.sender;
    }

    modifier isOwner() {
        require(msg.sender == owner, 'Not Owner');
        _;
    }
}

contract test14 is Owner {
    uint nombre;
    
    function setNombre(uint _n) public isOwner {
        nombre = _n;
    }

    function getNombre() public view returns(uint){
        return nombre;
    }
}
