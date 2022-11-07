// SPDX-License-Identifier: MIT

pragma solidity >= 0.6.0 <  0.9.0;

import "./SimpleStorage.sol";

contract StorageFactory is SimpleStorage{

    SimpleStorage[] public stArray;

    function createSimpleStorageContract() public {
        SimpleStorage st = new SimpleStorage();
        stArray.push(st);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        // Address
        // ABI
        SimpleStorage st = SimpleStorage(address(stArray[_simpleStorageIndex]));
        st.store(_simpleStorageNumber);
    }

    function stGet(uint256 _simpleStorageIndex) public view returns(uint256) {
        SimpleStorage st = SimpleStorage(address(stArray[_simpleStorageIndex]));
        return st.retrieve();
    }
}