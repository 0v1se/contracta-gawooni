pragma solidity ^0.4.0;

import "@daonomic/util/contracts/OwnableImpl.sol";
import "./GawooniToken.sol";

contract TokenHolder is OwnableImpl {
	GawooniToken public token;

	function TokenHolder(address _token) {
		token = GawooniToken(_token);
	}

	function transfer(address beneficiary, uint256 amount) onlyOwner public {
		token.transfer(beneficiary, amount);
	}

	function burn(uint256 amount) onlyOwner public {
		token.burn(amount);
	}
}
