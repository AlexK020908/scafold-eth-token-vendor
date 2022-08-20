pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";
import "hardhat/console.sol";

contract Vendor is Ownable {
    uint256 public constant tokensPerEth = 100;
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    YourToken public yourToken;
    address private immutable i_onwer;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
        i_onwer = msg.sender;
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        //msg.value is the amount of wei
        uint256 tokens = tokensPerEth * (msg.value / 1 ether);

        yourToken.transfer(msg.sender, tokensPerEth * msg.value);

        emit BuyTokens(msg.sender, msg.value / 1 ether, tokens);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner {
        (bool callSucess, ) = i_onwer.call{value: address(this).balance}("");
        require(callSucess, "call failed");
    }

    // ToDo: create a sellTokens(uint256 _amount) function:

    function sellTokens(uint256 _amount) public {
        yourToken.approve(address(this), _amount);
        yourToken.transferFrom(msg.sender, address(this), _amount);
        //have to use call so it takes care of the gas .... trasnferFrom does not transfer money to your wallet, it only gives the tokens back to the contract , so if
        //you want the funds as eth in  your wallet , you need to use call
        (bool callSucess, ) = i_onwer.call{value: address(this).balance}("");
        require(callSucess, "call failed");
    }

    modifier onlyOnwer() {
        require(msg.sender == i_onwer, "not the onwer");
        _;
    }
}
