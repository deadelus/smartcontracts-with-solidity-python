// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract factoryNumber {
    Number[] numbersContracts;

    function createNumberContract() external returns(address){
        Number n = new Number(100);
        numbersContracts.push(n);
        return address(n);
    }

    function getNumberByContract(address _Contract) external view returns(uint) {
        Number n = Number(_Contract);
        return n.getNombre();
    }

    function getAllContracts() external view returns(Number[] memory) {
        return numbersContracts;
    }

    function getAllContractsValues() external view returns(uint[] memory) {
        uint[] memory values = new uint[](numbersContracts.length);
        for(uint i; i < numbersContracts.length; i++) {
            Number n = numbersContracts[i];
            values[i] = n.getNombre();
        }
        return values;
    }

    function setNumberByContract(uint _id, uint _nb) external {
        Number n = numbersContracts[_id];
        return n.setNombre(_nb);
    }
}

contract Number {
    uint nombre;

    constructor(uint _nombre) {
        nombre = _nombre;
    }

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