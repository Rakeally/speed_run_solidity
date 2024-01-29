pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
	event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
	event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

	YourToken public yourToken;

	uint256 public constant tokensPerEth = 100;

	constructor(address tokenAddress) {
		yourToken = YourToken(tokenAddress);
	}

	function buyTokens() external payable {
		uint amountOfTokensTPay = msg.value * tokensPerEth;
		yourToken.transfer(msg.sender, amountOfTokensTPay);
		emit BuyTokens(msg.sender, msg.value, amountOfTokensTPay);
	}

	function withdraw() external onlyOwner {
		require(address(this).balance > 0, "Account balance is 0");
		(bool s, ) = address(msg.sender).call{ value: address(this).balance }(
			""
		);
		require(s);
	}

	function sellTokens(uint256 _amount) external {
		require(
			yourToken.balanceOf(msg.sender) > 0,
			"Insifficient token balance"
		);
		yourToken.transferFrom(msg.sender, address(this), _amount);
		uint ethToPay = _amount / tokensPerEth;
		(bool s, ) = address(msg.sender).call{ value: ethToPay * (10 ** 18) }(
			""
		);
		require(s);
		emit(msg.sender, _amount, ethToPay);
	}
}
