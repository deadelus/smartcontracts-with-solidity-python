// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import './14_Extends.sol';

contract test15 is Owner {
    uint nombre;
    
    function setNombre(uint _n) public isOwner {
        nombre = _n;
    }

    function getNombre() public view returns(uint){
        return nombre;
    }
}
