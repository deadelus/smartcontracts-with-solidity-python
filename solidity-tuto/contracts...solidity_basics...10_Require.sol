// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract test10 {
    uint nombre;

    function setNombre(uint _n) public {
        if (_n == 10) {
            revert('Nombre can be 10');
        }
        nombre = _n;
    }

    function setNombre2(uint _n) public {
        require(_n != 10, 'Nombre can be 10');
        nombre = _n;
    }

    function getNombre() public view returns (uint) {
        return nombre;
    }
}
