//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Lottery {
    address public manager;
    address[] players;
    
    
    constructor() {
        manager = msg.sender;
    }
    
    function buyTicket() public payable {
        require(msg.value > 0.01 ether, "Insufficient funds to buy a ticket.");
        
        players.push(msg.sender);
    }
    
    function getNumberOfPlayers() public view returns(uint) {
        return players.length;
    }
    
    function random() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }
    
    function selectWinner() public restricted {
        require(players.length > 0, "No players participated in the lottery.");
        
        uint index = random() % players.length;
        address payable winner = payable(players[index]);
        
        winner.transfer(address(this).balance);
        
        players = new address[](0); // Reset the players array for the next round
    }
    
    modifier restricted() {
        require(msg.sender == manager, "Only the manager can call this function.");
        _;
    }
}
