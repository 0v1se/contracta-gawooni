pragma solidity ^0.4.0;

import "./GawooniSale.sol";

contract PublicSale is GawooniSale {
	function PublicSale(
		address _mintableToken,
		address _btcToken,
		uint256 _start,
		uint256 _end,
		uint256 _cap)
	GawooniSale(_mintableToken, _btcToken, _start, _end, _cap) {

	}

	function getBonus(uint256 sold) constant public returns (uint256) {
		return getTimeBonus(sold) + getAmountBonus(sold);
	}

	function getTimeBonus(uint256 sold) internal returns (uint256) {
		uint256 interval = (now - start) / (86400);
		if (interval < 2) {
			return sold.mul(45).div(100);
		} else if (interval < 7) {
			return sold.mul(30).div(100);
		} else if (interval < 14) {
			return sold.mul(20).div(100);
		} else if (interval < 21) {
			return sold.mul(10).div(100);
		} else {
			return 0;
		}
	}

	function getAmountBonus(uint256 sold) internal returns (uint256) {
		if (sold >= 100000 * 10**18) {
			return sold.mul(75).div(100);
		} else {
			return 0;
		}
	}
}
