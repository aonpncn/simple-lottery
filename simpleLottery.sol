// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {

    address manager;
    address payable[] players;

    constructor(){
        manager = msg.sender;
    }

    // return all amount of balance in this smart contract
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function buyLottery() public payable {
        require(msg.value == 1 ether, "The lottery ticket price is 1 ETH each.");
        players.push(payable(msg.sender));
    }

    function getLength() public view returns(uint){
        return players.length;
    }
    
    function randomNumber() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,players.length)));
    }

    function selectWinner() public{
        require(msg.sender == manager, "You are not manager.");
        require(getLength() >= 2, "Cannot find the winner b/c player less than 2");

        uint pickRandom = randomNumber();
        uint selectIndex = pickRandom % players.length;

        address payable winner;
        winner = players[selectIndex];
        winner.transfer(getBalance());
        // reset
        players = new address payable[](0);
    }

}