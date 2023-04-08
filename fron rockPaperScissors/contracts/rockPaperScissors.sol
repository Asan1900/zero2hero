// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface IERC721 {
    function balanceOf(address owner) external view returns (uint256);
}

contract RockPaperScissors {

    enum Hand {
        rock,
        paper,
        scissors
    }

    mapping(address => Hand) private playerHand;
    address private player1;
    address private player2;
    bool private gameStarted;

    event GameStarted(address address1, address address2);
    event GameEnded(address winner);

    function startGame(address _player2) public {
        require(!gameStarted, "Game already started");
        require(_player2 != address(0), "Invalid index");

        player1 = msg.sender;
        player2 = _player2;
        gameStarted = true;

        emit GameStarted(player1, player2);
    }

    function makeMove(Hand _hand) public {
        require(gameStarted, "Game not started yet");
        require(msg.sender == player1 || msg.sender == player2, "Not a player");
        require(playerHand[msg.sender] == Hand(0), "Hand already played");

        playerHand[msg.sender] = _hand;

        if (playerHand[player1] != Hand(0) && playerHand[player2] != Hand(0)) {
            Hand winnerHand = DetermineWinner(playerHand[player1], playerHand[player2]);
            address winner = winnerHand == playerHand[player1] ? player1 : player2;
            emit GameEnded(winner);

            playerHand[player1] = Hand(0);
            playerHand[player2] = Hand(0);
            player1 = address(0);
            player2 = address(0);
            gameStarted = false;
        }
    }

    function DetermineWinner(Hand _hand1, Hand _hand2) private pure returns (Hand) {
        if (_hand1 == _hand2) {
            return Hand(0);
        }
        if (_hand1 == Hand.rock && _hand2 == Hand.scissors || _hand1 == Hand.paper && _hand2 == Hand.rock || _hand1 == Hand.scissors && _hand2 == Hand.paper) {
            return _hand1;
        } else {
            return _hand2;
        }
    }
}
