// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract Lottery {
    // owner address
    address public owner;
    // The max participants in a lottery
    uint256 public maxParticipants = 10;
    // The min number of participants
    uint256 public minParticipants = 5;
    // The number of winners
    uint256 public winnerCount = 3;
    // The list of participants
    address[] public participants;
    // The list if winners
    address[] public winners;
    // Participant mapping
    mapping(address => bool) public isParticipant;
    // Winner mapping
    mapping(address => bool) public isWinner;
    // The entry fee
    uint public entryFee = 0.000015 ether;
    // The current number of participants
    uint8 public participantCount = 0;
    // State of the lottery
    bool public lotteryOpen = true;
    uint256 public totalPayout = 0;

    // event player entered the lottery
    event PlayerEntered(address player);

    // event lottery ended
    event LotteryEnded(address[] winners);

    // event lottery reset
    event LotteryReset();

    constructor() {
        owner = msg.sender;
    }

    function enter() public payable {
        require(lotteryOpen, "The lottery is closed");
        require(msg.value == entryFee, "The entry fee is 0.000015 ether");
        require(participantCount < maxParticipants, "The lottery is full");
        require(!isParticipant[msg.sender], "You are already a participant");

        participants.push(msg.sender);
        participantCount++;
        isParticipant[msg.sender] = true;

        if (participantCount == maxParticipants) {
            lotteryOpen = false;
        }
        emit PlayerEntered(msg.sender);
    }

    // function to end the lottery and select winnerCount different winners. Remove them from the participants list and add them to the winners list.abi
    function endLottery() public {
        require(lotteryOpen, "The lottery is already closed");
        require(participantCount >= minParticipants, "The lottery is not full");

        for (uint i = 0; i < winnerCount; i++) {
            uint256 winnerIndex = uint256(
                keccak256(
                    abi.encodePacked(block.timestamp, block.prevrandao, i)
                )
            ) % participantCount;
            winners.push(participants[winnerIndex]);
            isWinner[participants[winnerIndex]] = true;

            // Remove the winner from the participants list
            participants[winnerIndex] = participants[participantCount - 1];
            participantCount--;
        }

        // calculate half, thirty percent and twenty percent of the total balance for the winners
        uint256 totalBalance = address(this).balance;
        uint256 half = totalBalance / 2;
        uint256 thirtyPercent = (totalBalance * 30) / 100;
        uint256 twentyPercent = (totalBalance * 20) / 100;
        // do the transfers
        // TODO: use balances and withdraw method for claiming rewards
        // For now, to keep the interactions simple, we are using transfer
        payable(winners[0]).transfer(half);
        payable(winners[1]).transfer(thirtyPercent);
        payable(winners[2]).transfer(twentyPercent);

        // set lottery open to false
        lotteryOpen = false;
        totalPayout = totalBalance;
        emit LotteryEnded(winners);
    }

    function resetLottery() public {
        for (uint i = 0; i < participantCount; i++) {
            isParticipant[participants[i]] = false;
        }
        if (!lotteryOpen) {
            for (uint i = 0; i < winnerCount; i++) {
                isWinner[winners[i]] = false;
            }
        }
        delete participants;
        delete winners;
        participantCount = 0;
        lotteryOpen = true;
        totalPayout = 0;
        emit LotteryReset();
    }

    function isAlreadyParticipating(
        address _address
    ) public view returns (bool) {
        return isParticipant[_address];
    }

    function getParticipants() public view returns (address[] memory) {
        return participants;
    }

    function isAddressWinner(address _address) public view returns (bool) {
        return isWinner[_address];
    }

    function getWinners() public view returns (address[] memory) {
        return winners;
    }
}
