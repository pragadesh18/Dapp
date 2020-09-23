const { assert } = require('chai');
const program = artifacts.require("./program.sol");

require('chai')
  .use(require('chai-as-promised'))
  .should()

  contract('program', function(account) {
    let prog 
    before(async () => {
      prog = await program.new()
    })

    describe("program details", async() => {
        it("Create program", async() => {
          await prog.Program_detail(account[0],"ashok",1,5000,1,"abcd","@gmail")
          let details  = await prog.program_info.call(1)
          assert.equal(details.manager_id,account[0],"id doesn't match")
          assert.equal(details.Fund_needed,5000,"Fund doesn't match")

        })

        it("Give proof", async() => {
            await prog.completion_proof(account[0],1,"gvh","@gmail","5966")
            let details  = await prog.program_proof.call(1)
            assert.equal(details.manager_id,account[0],"details don't match")
          })
    })

    describe("serviceprovider", async() => {
        it("registration", async() => {
          await prog.ServiceProvider_Info(account[1],"manoj","abcd","526413","@gmail",1)
          let details  = await prog.serviceprovider.call(account[1],1)
          assert.equal(details.Name,"manoj","Name doesn't match")

        })

        it("providing proof", async() => {
            await prog.serviceproof_info(account[1],1,"food","fyfgyf","@gmail","5966")
            let details  = await prog.provider_proof.call(account[1],1)
            assert.equal(details.provided_service,"food","details doesn't match")
          })
    })

    describe("Volunteer", async() => {
        it("registration", async() => {
          await prog.Volunteer_info(account[2],"geetha","food distribution","69533","@gmail","1")
          let details  = await prog.volunteer.call(account[2],1)
          assert.equal(details.Name,"geetha","name doesn't match")

        })

        it("Give proof", async() => {
            await prog.volunteerproof_Info(account[2],"grocery",1,2,"gvh","@gmail","5966")
            let details  = await prog.volunteer_proof.call(account[2],1)
            assert.equal(details.duration,2,"duration doesn't match")
          })
    })
})