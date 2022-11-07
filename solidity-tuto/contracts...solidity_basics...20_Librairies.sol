// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/Strings.sol";

contract Libs {

    function concat(string memory _str, uint _a, uint _b) external pure returns(string memory) {
        string memory res = string(abi.encodePacked(_str, Strings.toString(_a), Strings.toString(_b)));
        return res;
    }

}