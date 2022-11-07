// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract test9 {
    enum state {ordered, shipped, delivered}

    struct product {
        string SKU;
        test9.state _state;
    }

    mapping(address => product) Orders;

    function order(address _address, string memory _SKU) public {
        product memory p = product(_SKU, state.ordered);
        Orders[_address] = p;
    }

    function ship(address _address) public {
        Orders[_address]._state = state.shipped;
    }

    function getSKU(address _address) public view returns (string memory) {
        return Orders[_address].SKU;
    }

    function getState(address _address) public view returns (state) {
        return Orders[_address]._state;
    }
}
