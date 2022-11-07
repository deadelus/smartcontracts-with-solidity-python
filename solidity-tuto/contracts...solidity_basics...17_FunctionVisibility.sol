// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract Nombre {
    uint internal nombre;

    function getNombre() internal view returns(uint) {
        return nombre;
    }

    function setNombre(uint _nombre) internal {
        nombre = _nombre;
    } 
}

contract Nombre2 is Nombre {

    function getNombreX2() external view returns(uint) {
        return getNombre();
    }

    function setNombreX2(uint _nombre) external {
        setNombre(multiple(_nombre, 2));
    }

    function multiple(uint _n, uint _multiplicator) private pure returns(uint) {
        return _n * _multiplicator;
    }
}