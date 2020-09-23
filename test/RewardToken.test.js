const { assert } = require('chai');
require('chai')
  .use(require('chai-as-promised'))
  .should()

const rewardtoken= artifacts.require("RewardToken");

contract("RewardToken", function([owner,investor]) {
    let RToken;
  const _name = "Reward Token";
  const _symbol = "RXT";
  const _decimals = 18;
  const _total_supply = 1000000000000000000000000;

  before(async () => {
    RToken = await rewardtoken.new({from:owner})
  })

  describe("check if the smart contract has been created as set in the variables", async() => {
    it(" check token name", async() => {
      const name = await RToken.name()
      assert.equal(name,_name,"doesn't match")
    })

    it("check token symbol", async() => {
        const symbol = await RToken.symbol()
        assert.equal(symbol,_symbol,"doesn't match")
    })

    it("check token decimals", async() => {
        const decimals = await RToken.decimals()
        assert.equal(decimals,_decimals,"doesn't match")
    })

    it("check total supply", async() => {
        const totalSupply = await RToken.totalSupply()
        assert.equal(totalSupply,_total_supply,"doesn't match")
    })
  })

  describe("owner balance", async() => {
    it("owner", async() => {
      const Balance = await RToken.balanceOf(owner)
      assert.equal(Balance,_total_supply,"not same")
    })
  })


  describe("check transfer function", async() => {
    it("for transfer", async() => {
      await RToken.transfer(investor, 1000,{from:owner})
      const investorBalance = await RToken.balanceOf(investor)
      assert.equal(investorBalance,1000,"didn't transfer")
    })
  })
})