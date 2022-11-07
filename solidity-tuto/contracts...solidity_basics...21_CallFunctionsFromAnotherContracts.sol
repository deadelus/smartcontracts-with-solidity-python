// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

interface contractBinterface {
    function getNombre() external view returns(uint);
    function setNombre(uint _nombre) external;
}


contract contractA {
    address addressB;

    function setAddressB(address _addressB) external {
        addressB = _addressB;
    }

    function callGetNb() external view returns(uint) {
        contractBinterface b = contractBinterface(addressB);
        return b.getNombre();
    }

    function callSetNb(uint _nb) external {
        contractBinterface b = contractBinterface(addressB);
        return b.setNombre(_nb);
    }
}

contract contractB {
    uint nombre;

    function getNombre() external view returns(uint) {
        return nombre;
    }

    function setNombre(uint _nombre) external {
        nombre = _nombre;
    }

    function setNombreX2(uint _nombre) external {
        nombre = _nombre * 2;
    } 
}