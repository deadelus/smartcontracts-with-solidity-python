// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract Events {

    uint[] numbers;
    event numberAdded(address by, uint number);
    
    function addNumber(uint _nb) external {
        numbers.push(_nb);
        emit numberAdded(msg.sender, _nb);
    }
}