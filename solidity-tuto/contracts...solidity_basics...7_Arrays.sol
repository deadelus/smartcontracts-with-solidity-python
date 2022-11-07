// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract test7 {

    uint[] nombre;

    
    function addValue(uint _val) public {
        nombre.push(_val);
    }

    function updateValue(uint _index, uint _val) public {
        nombre[_index] = _val;
    }

    function deleteValue(uint _index) public {
        delete nombre[_index];
    }

    function getValue(uint _index) public view returns(uint) {
        return nombre[_index];
    }

    function getNombreX2() public view returns(uint[] memory) {
        uint size = nombre.length;
        uint[] memory nombreX2 = new uint[](size);
        for (uint i = 0; i < size; i++) {
            nombreX2[i] = _multiple(nombre[i], 2);
        }
        return nombreX2;
    }

    function _multiple(uint _n, uint _multiplicator) private pure returns(uint) {
        return _n * _multiplicator;
    }

    function sum(uint[] memory tab) public pure returns(uint[] memory) {
        return tab;
    }
}
