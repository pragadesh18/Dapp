const { assert } = require('chai');
require('chai')
  .use(require('chai-as-promised'))
  .should()

const blockXToken= artifacts.require("BlockXToken");

contract("BlockXToken", function([owner,investor]) {
    let BToken;
  const _name = "Block X Token";
  const _symbol = "BXT";
  const _decimals = 18;
  const _total_supply = 1000000000000000000000000;

  before(async () => {
    BToken = await blockXToken.new({from:owner})
  })

  describe("check if the smart contract has been created as set in the variables", async() => {
    it(" check token name", async() => {
      const name = await BToken.name()
      assert.equal(name,_name,"doesn't match")
    })

    it("check token symbol", async() => {
        const symbol = await BToken.symbol()
        assert.equal(symbol,_symbol,"doesn't match")
    })

    it("check token decimals", async() => {
        const decimals = await BToken.decimals()
        assert.equal(decimals,_decimals,"doesn't match")
    })

    it("check total supply", async() => {
        const totalSupply = await BToken.totalSupply()
        assert.equal(totalSupply,_total_supply,"doesn't match")
    })
  })

  describe("owner balance", async() => {
    it("owner", async() => {
      const Balance = await BToken.balanceOf(owner)
      assert.equal(Balance,_total_supply,"not same")
    })
  })


  describe("check transfer function", async() => {
    it("for transfer", async() => {
      await BToken.transfer(investor, 1000,{from:owner})
      const investorBalance = await BToken.balanceOf(investor)
      assert.equal(investorBalance,1000,"didn't transfer")
    })
  })
})