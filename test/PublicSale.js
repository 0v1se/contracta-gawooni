var Sale = artifacts.require('PublicSale.sol');
var Token = artifacts.require('GawooniToken.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;

contract("PublicSale", accounts => {
  let token;

  beforeEach(async function() {
    token = await Token.new();
  });

  function bn(value) {
    return new web3.BigNumber(value);
  }

  it("should calculate bonus correctly", async () => {
    async function testBonus(days, sold, testBonus) {
        var diff = -days * 86400;
        var now = new Date().getTime() / 1000;
        var sale = await Sale.new(token.address, 100, now + diff, now + diff + 86400 * 100, 1000000);
        var result = await sale.getBonus(sold);
        assert(testBonus.equals(result), testBonus.toNumber() + " != " + result.toNumber());
    }

	await testBonus(0, 100, bn(45));
	await testBonus(1, 100, bn(45));
	await testBonus(2, 100, bn(30));
    await testBonus(6, 100, bn(30));
    await testBonus(7, 100, bn(20));
    await testBonus(14, 100, bn(10));
    await testBonus(21, 100, bn(0));

    await testBonus(21, bn("50000000000000000000000"), bn("0"));
    await testBonus(21, bn("100000000000000000000000"), bn("75000000000000000000000"));
  });
});
