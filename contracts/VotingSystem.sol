// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract VotingSystem {
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    mapping(uint256 => Candidate) public candidates;
    mapping(address => bool) public hasVoted;

    uint256 public candidateCount;
    address public owner;

    event CandidateAdded(uint256 id, string name);
    event VoteCasted(address voter, uint256 candidateId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Add candidate (Owner only)
    function addCandidate(string memory _name) public onlyOwner {
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
        emit CandidateAdded(candidateCount, _name);
    }

    // Cast vote
    function vote(uint256 _candidateId) public {
        require(!hasVoted[msg.sender], "Already voted");
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate");

        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;

        emit VoteCasted(msg.sender, _candidateId);
    }

    // Get candidate details
    function getCandidate(uint256 _candidateId) public view returns (string memory, uint256) {
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate");
        Candidate memory c = candidates[_candidateId];
        return (c.name, c.voteCount);
    }

    // Get winner (highest votes)
    function getWinner() public view returns (string memory winnerName, uint256 winnerVotes) {
        uint256 maxVotes = 0;
        uint256 winnerId = 0;

        for (uint256 i = 1; i <= candidateCount; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }

        if (winnerId == 0) {
            return ("No Winner Yet", 0);
        }

        return (candidates[winnerId].name, candidates[winnerId].voteCount);
    }
}

