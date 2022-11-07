// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract Owner {
    address owner;
    bool paused;
    uint nombre;

    constructor() {
        owner = msg.sender;
    }

    function setPaused(bool _paused) public {
        require(msg.sender == owner, 'Not Owner');
        paused = _paused;
    }
    
    function setNombre(uint _n) public {
        require(paused == false, 'Paused Contract');
        require(msg.sender == owner, 'Not owner');
        nombre = _n;
    }

    function getNombre() public view returns (uint) {
        require(paused == false, 'Paused Contract');
        return nombre;
    }

    function destroy(address payable _to) public {
        require(msg.sender == owner, 'Not owner');
        selfdestruct(_to);
    }
}
