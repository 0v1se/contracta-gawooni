pragma solidity ^0.4.18;

import "@daonomic/sale/contracts/MintingSale.sol";
import "@daonomic/util/contracts/OwnableImpl.sol";
import "@daonomic/sale/contracts/CappedBonusSale.sol";
import "@daonomic/sale/contracts/PeriodSale.sol";
import "@daonomic/util/contracts/Pausable.sol";

contract GawooniSale is OwnableImpl, MintingSale, CappedBonusSale, PeriodSale {
	address public btcToken;
	uint256 public ethRate = 1000 * 10**18;
	uint256 public btcEthRate = 10 * 10**10;

	function GawooniSale(
		address _mintableToken,
		address _btcToken,
		uint256 _start,
		uint256 _end,
		uint256 _cap)
	MintingSale(_mintableToken)
	CappedBonusSale(_cap)
	PeriodSale(_start, _end) {
		btcToken = _btcToken;
		RateAdd(address(0));
		RateAdd(_btcToken);
	}

	function getRate(address _token) constant public returns (uint256) {
		if (_token == btcToken) {
			return btcEthRate * ethRate;
		} else if (_token == address(0)) {
			return ethRate;
		} else {
			return 0;
		}
	}

	event EthRateChange(uint256 rate);

	function setEthRate(uint256 _ethRate) onlyOwner public {
		ethRate = _ethRate;
		EthRateChange(_ethRate);
	}

	event BtcEthRateChange(uint256 rate);

	function setBtcEthRate(uint256 _btcEthRate) onlyOwner public {
		btcEthRate = _btcEthRate;
		BtcEthRateChange(_btcEthRate);
	}

	function withdrawBtc(bytes _to, uint256 _value) onlyOwner public {
		burnWithData(btcToken, _value, _to);
	}

	function transferTokenOwnership(address newOwner) onlyOwner public {
		OwnableImpl(token).transferOwnership(newOwner);
	}

	function pauseToken() onlyOwner public {
		Pausable(token).pause();
	}

	function unpauseToken() onlyOwner public {
		Pausable(token).unpause();
	}
}
