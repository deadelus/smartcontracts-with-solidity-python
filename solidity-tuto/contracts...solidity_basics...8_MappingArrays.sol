// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract test8 {

    struct eleve {
        string name;
        uint[] notes;
    }
    
    mapping (address => eleve) Eleves;

    function addNote(address _eleve, uint _note) public {
        Eleves[_eleve].notes.push(_note);
    }

    function addName(address _eleve, string memory _name) public {
        Eleves[_eleve].name = _name;
    }

    function getNotes(address _eleve) public view returns (uint[] memory) {
        return Eleves[_eleve].notes;
    }

    function getName(address _eleve) public view returns (string memory) {
        return Eleves[_eleve].name;
    }
}
