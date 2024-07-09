// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool authorized;
        bool voted;
        uint vote;
    }

    address public owner;
    string public electionName;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    uint public totalVotes;

    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }

    constructor(string memory _name) {
        owner = msg.sender;
        electionName = _name;
    }

    function addCandidate(string memory name) ownerOnly public {
        candidates.push(Candidate(candidates.length, name, 0));
    }

    function authorize(address voter) ownerOnly public {
        voters[voter].authorized = true;
    }

    function vote(uint candidateId) public {
        require(!voters[msg.sender].voted);
        require(voters[msg.sender].authorized);

        voters[msg.sender].vote = candidateId;
        voters[msg.sender].voted = true;

        candidates[candidateId].voteCount += 1;
        totalVotes += 1;
    }

    function end() ownerOnly public {
        selfdestruct(payable(owner));
    }
}
