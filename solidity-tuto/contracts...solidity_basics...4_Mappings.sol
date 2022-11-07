// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract test4 {
    mapping(address => uint) Balances;

    function getBalance(address _address) public view returns(uint) {
        return Balances[_address];
    }

    receive() external payable {
        Balances[msg.sender] = msg.value;
    }
}
