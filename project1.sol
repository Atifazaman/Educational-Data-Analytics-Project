// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

// This contract will manage educational data
contract EducationAnalytics is Ownable {
    // Structure to hold grade information
    struct Grade {
        uint256 score;
        string subject;
    }

    // Mapping from student address to an array of grades
    mapping(address => Grade[]) private studentGrades;

    // Event to log the addition of a new grade
    event GradeAdded(address indexed student, string subject, uint256 score);

    // Event to log the generation of a report
    event ReportGenerated(address indexed student, string reportSummary);

    // Function to add a grade for a student
    function addGrade(address _student, string memory _subject, uint256 _score) public onlyOwner {
        require(_score >= 0 && _score <= 100, "Score must be between 0 and 100");

        studentGrades[_student].push(Grade({
            score: _score,
            subject: _subject
        }));

        emit GradeAdded(_student, _subject, _score);
    }

    // Function to get grades for a student
    function getGrades(address _student) public view returns (Grade[] memory) {
        return studentGrades[_student];
    }

    // Function to generate a summary report for a student
    function generateReport(address _student) public {
        Grade[] memory grades = studentGrades[_student];
        require(grades.length > 0, "No grades found for this student");

        uint256 totalScore = 0;
        uint256 subjectCount = grades.length;

        for (uint256 i = 0; i < subjectCount; i++) {
            totalScore += grades[i].score;
        }

        uint256 averageScore = totalScore / subjectCount;

        // Generate a report summary
        string memory reportSummary = string(abi.encodePacked(
            "Student Report:\n",
            "Total Subjects: ", uint2str(subjectCount), "\n",
            "Average Score: ", uint2str(averageScore)
        ));

        emit ReportGenerated(_student, reportSummary);
    }

    // Helper function to convert uint to string
    function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        return string(bstr);
    }
}
