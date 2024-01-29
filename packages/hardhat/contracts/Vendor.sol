pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
	event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

	YourToken public yourToken;

	uint256 public constant tokensPerEth = 100;

	constructor(address tokenAddress) {
		yourToken = YourToken(tokenAddress);
	}

	function buyTokens() external payable {
		// require(msg.value > 0, "Amount must be greater than 0");
		uint amountOfTokensTPay = msg.value * tokensPerEth;
		yourToken.transfer(msg.sender, amountOfTokensTPay);
		emit BuyTokens(msg.sender, msg.value, amountOfTokensTPay);
	}

	function withdraw() external onlyOwner {
		// 	// require(payable(msg.sender).transfer(address(this).balance), "hey");
		// 	//
		// 	// (bool s, ) = address(msg.sender).call{ value: address(this).balance }(
		// 	// 	""
		// 	// );
		require(address(this).balance > 0, "Account balance is 0");
		(bool s, ) = address(msg.sender).call{ value: address(this).balance }(
			""
		);
		require(s);
	}
	// ToDo: create a payable buyTokens() function:

	// ToDo: create a withdraw() function that lets the owner withdraw ETH

	// ToDo: create a sellTokens(uint256 _amount) function:
}
