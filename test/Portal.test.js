const BlockXToken = artifacts.require("./BlockXToken.sol");
const RewardToken = artifacts.require("./RewardToken.sol");
const program = artifacts.require("./program.sol");
const Portal = artifacts.require("./Portal.sol");

require('chai')
  .use(require('chai-as-promised'))
  .should()

function tokens(n) {
  return web3.utils.toWei(n, 'ether');
}

contract('Portal', ([owner, investor]) => {
  let BToken, RToken, prog, portal
  before(async () => {
    //Load Contracts
    BToken = await BlockXToken.new()
    RToken = await RewardToken.new()
    prog = await program.new()
    portal = await Portal.new(BToken.address, RToken.address, prog.address)

    // Transfer all Reward to Farm (1 million)
    await RToken.transfer(portal.address, tokens('10000'))
  })
 


  describe('Block X deployment', async () =>{
    it('has a name', async () => {
      const name = await BToken.name()
      assert.equal(name, 'Block X Token')
    })
  })
  describe('Reward Token deployment', async () =>{
    it('has a name', async () => {
      const name = await RToken.name()
      assert.equal(name, 'Reward Token')
    })
  })
  describe('Portal deployment', async () =>{
    it('has a name', async () => {
      const name = await portal.name1()
      assert.equal(name, 'BlockX Platform')
    })
    it('contract has tokens', async () => {
      let balance = await RToken.balanceOf(portal.address)
      assert.equal(balance.toString(), tokens('100000'),'no')
    })
  })
  describe('Farming tokens', async () => {

    it('rewards investors for staking  BTokens', async () => {
      let result

      // Check investor balance before staking
      result = await BToken.balanceOf(investor)
      assert.equal(result.toString(), tokens('100'), 'investor Block X wallet balance correct before staking')

      // Stake Block X Tokens
      await BToken.approve(portal.address, tokens('100'), { from: investor })
      await portal.stakeTokens(tokens('100'), { from: investor })

      // Check staking result
      result = await BToken.balanceOf(investor)
      assert.equal(result.toString(), tokens('0'), 'investor Block X wallet balance correct after staking')

      result = await BToken.balanceOf(portal.address)
      assert.equal(result.toString(), tokens('100'), 'Portal Block X balance correct after staking')

      result = await portal.stakingBalance(investor)
      assert.equal(result.toString(), tokens('100'), 'investor staking balance correct after staking')

      result = await portal.isStaking(investor)
      assert.equal(result.toString(), 'true', 'investor staking status correct after staking')
      // Issue Tokens
      await portal.issueTokens({ from: owner })

      // Check balances after issuance
      result = await RToken.balanceOf(investor)
      assert.equal(result.toString(), tokens('100'), 'investor Reward Token wallet balance correct affter issuance')

      // Ensure that only onwer can issue tokens
      await portal.issueTokens({ from: investor }).should.be.rejected;

      // Unstake tokens
      await portal.unstakeTokens({ from: investor })

      // Check results after unstaking
      result = await BToken.balanceOf(investor)
      assert.equal(result.toString(), tokens('100'), 'investor Block X wallet balance correct after staking')

      result = await BToken.balanceOf(portal.address)
      assert.equal(result.toString(), tokens('0'), 'Token Farm Block X balance correct after staking')

      result = await portal.stakingBalance(investor)
      assert.equal(result.toString(), tokens('0'), 'investor staking balance correct after staking')

      result = await portal.isStaking(investor)
      assert.equal(result.toString(), 'false', 'investor staking status correct after staking')
    })
  })
})




