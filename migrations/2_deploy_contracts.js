const BlockXToken = artifacts.require("./BlockXToken.sol");
const RewardToken = artifacts.require("./RewardToken.sol");
const program = artifacts.require("./program.sol");
const Portal = artifacts.require("./Portal.sol");

module.exports = async function(deployer, network, accounts){
    await deployer.deploy(BlockXToken)
    const BToken = await BlockXToken.deployed()

    await deployer.deploy(RewardToken)
    const RToken = await RewardToken.deployed()

    await deployer.deploy(program)
    const prog = await program.deployed()

    await deployer.deploy(Portal, BToken.address, RToken.address, prog.address)
    const portal = await Portal.deployed()

    await BToken.transfer(portal.address, '1000000000000000000000000')
    await RToken.transfer(accounts[1], '1000000000000000000000000')

};