// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract Nombre {
    uint[] public arr; // storage
    uint nombre;

    function doStuffMemory() external {
        arr.push(3);
        arr.push(8);

        uint[] memory arr2 = arr; // in memory
        arr2[0] = 0; // arr[0] = 3
    }

    function doStuffStorage() external {
        arr.push(3);
        arr.push(8);

        uint[] storage arr2 = arr; // pointeur
        arr2[0] = 0; // arr[0] = 0
    }

    function doStuffCalldata(uint[] calldata _users) external { // external => calldata
        nombre = _users[0];
    }
}