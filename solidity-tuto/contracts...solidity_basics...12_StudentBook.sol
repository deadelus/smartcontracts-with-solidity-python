// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract StudentBook {

    address owner;

    struct Grades {
        string subject;
        uint grade;
    }

    struct Student {
        string firstname;
        string lastname;
        uint gradesCount;
        mapping(uint => Grades) grades;
    }

    mapping(address => Student) Students;

    constructor() {
        owner = msg.sender;
    }

    function addStudent(address _address, string memory _fname, string memory _lname) public {
        require(msg.sender == owner, 'Not Owner');
        bytes memory firstnameOfAddress =  bytes(Students[_address].firstname);
        require(firstnameOfAddress.length == 0, 'Student Already Exists');
        Students[_address].firstname = _fname;
        Students[_address].lastname = _lname;
    }

    function addGrade(address _address, uint _grade, string memory _suject) public {
        require(msg.sender == owner, 'Not Owner');
        bytes memory firstnameOfAddress =  bytes(Students[_address].firstname);
        require(firstnameOfAddress.length > 0, 'Student Not Exists');

        uint index = Students[_address].gradesCount;
        Students[_address].grades[index].subject = _suject;
        Students[_address].grades[index].grade = _grade;
        Students[_address].gradesCount++;
    }

    function getGrades(address _address) public view returns (uint[] memory) {
        require(msg.sender == owner, 'Not Owner');
        bytes memory firstnameOfAddress =  bytes(Students[_address].firstname);
        require(firstnameOfAddress.length > 0, 'Student Not Exists');

        uint nbOfGrades = Students[_address].gradesCount;
        uint[] memory grades = new uint[](nbOfGrades);

        for(uint i = 0; i < nbOfGrades; i++) {
            grades[i] = (Students[_address].grades[i].grade);
        }

        return grades;
    }
}