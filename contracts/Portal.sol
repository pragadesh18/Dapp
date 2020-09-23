pragma solidity ^0.5.0;

import "./BlockXToken.sol";
import "./RewardToken.sol";
import "./program.sol";

contract portal {
    string  public name1 = "PLATFORM";
    RewardToken public RToken;
    BlockXToken public BToken;
    program public prog;

    mapping(uint => uint) public DonationReceived;
   
     constructor(address _RToken, address _BToken, address _prog) public {
        RToken = RewardToken(_RToken);
        BToken = BlockXToken(_BToken);
        prog = program(_prog);
        validater_info.push(validater_details({validater:msg.sender,reward_tokens:0}));
     }
     
    mapping(address =>mapping(uint => bool)) public ans;
    mapping(uint => bool) public ans_prog;
   
    struct validater_details{
        address validater;  
        uint reward_tokens;
    }
   
    validater_details[] public validater_info;
   
    struct Doner{
        address id;
        string Name;
        uint Amount;
        string Contact_Details;
        string mail_id;
        bool donated;
    }
   
    mapping(address => mapping(uint => uint)) public stakingBalance;
    mapping(address => mapping(uint => Doner)) public doner;
    mapping(address => mapping(uint => uint)) public role;
    mapping(address => bool) public blacklisted;
    mapping(address => mapping(uint => bool)) public isRegistered;
    mapping(address => mapping(uint => address)) public validater;
   
    uint project_count=0;
   
   
    function Program_creation(string memory name, uint Fund_needed, uint duration, string memory descrption,string memory email) public{
        require(!blacklisted[msg.sender], "Not allowed");
        project_count = project_count + 1;
        if(RToken.balanceOf(msg.sender)<250)
        {
            stakeTokens(msg.sender,project_count,250);
        }
        prog.Program_detail(msg.sender,name,project_count,Fund_needed, duration, descrption,email);
        isRegistered[msg.sender][project_count] = true;
        role[msg.sender][project_count] = 1;
        check_validater(msg.sender);
    }
   
    function project_completion_proof(uint program_id,string memory descrption, string memory mail_id, string memory contact_details) public{
       prog.completion_proof(msg.sender,program_id,descrption, mail_id, contact_details);
       select_validater(msg.sender, program_id);
    }
   
    function Donate(uint program_id,string memory name,string memory email,string memory contact_details, uint amount) public {
        require(!blacklisted[msg.sender], "Not allowed");
        require(amount > 0, "amount cannot be 0");
        uint Fund_needed = prog.Fund_details(program_id);
        uint required = Fund_needed - DonationReceived[program_id];
        if(required<amount){
            amount=required;
        }
        BToken.transferFrom(msg.sender, address(this), amount);
        if(!doner[msg.sender][program_id].donated){
            doner[msg.sender][program_id] = Doner(msg.sender,name,0,contact_details,email,true);
        }
        doner[msg.sender][program_id].Amount = doner[msg.sender][program_id].Amount + amount;
        DonationReceived[program_id] = DonationReceived[program_id] + amount;
        if(amount>250){
            RToken.transfer(msg.sender,10);
        }
        else if(amount>=200){
            RToken.transfer(msg.sender,8);
        }
        else if(amount>=100){
            RToken.transfer(msg.sender,4);
        }
        check_validater(msg.sender);
    }
   
    function register_ServiceProvider(string memory name,string memory title,string memory contact_details, string memory email, uint program_id) public{
        require(!blacklisted[msg.sender], "Not allowed");
        require(!isRegistered[msg.sender][program_id],"Already registered");
        prog.ServiceProvider_Info(msg.sender,name,title,contact_details,email,program_id);
        isRegistered[msg.sender][program_id] = true;
        role[msg.sender][program_id] = 2;
        check_validater(msg.sender);
    }
   
    function register_Volunteer(string memory name,string memory title,string memory contact_details, string memory email, uint program_id) public {
        require(!blacklisted[msg.sender], "Not allowed");
        require(!isRegistered[msg.sender][program_id],"Already registered");
        prog.Volunteer_info(msg.sender,name,title,contact_details,email,program_id);
        isRegistered[msg.sender][program_id] = true;
        role[msg.sender][program_id] = 3;
        check_validater(msg.sender);
    }
   
    function volunteerproof(string memory work_by_volunteer,uint program_id, uint duration, string memory desc,string memory email, string memory contact) public{
        prog.volunteerproof_Info(msg.sender, work_by_volunteer,program_id, duration, desc, email, contact);
        select_validater(msg.sender, program_id);
    }
   
    function serviceproof(uint program_id,string memory provided_service, string memory descrption, string memory mail_id, string memory contact_details) public{
        prog.serviceproof_info(msg.sender,program_id, provided_service, descrption,mail_id, contact_details);
        select_validater(msg.sender, program_id);
    }
   
    function validateproof(address Address,uint id,bool ver) public{
        ans[Address][id]=ver;
        RToken.transfer(validater[Address][id],2);
        check_validater(validater[Address][id]);
    }
   
    function validateprog(address Address, uint id,bool ver) public{
        ans_prog[id]=ver;
        RToken.transfer(validater[Address][id],2);
        check_validater(validater[Address][id]);
    }
   
    function check_validater(address Address) public {
        uint i = validater_info.length;
        if(i==0){
            validater_info.push(validater_details({validater:Address,reward_tokens:RToken.balanceOf(Address)}));
        }
        else{
            if(validater_info[i-1].reward_tokens<= RToken.balanceOf(Address)){
                validater_info.push(validater_details({validater:Address,reward_tokens:RToken.balanceOf(Address)}));
            }
        }
    }
   
    function select_validater(address Address, uint id) public {
        uint index = validater_info.length-1;
        for(uint i=index;i>=0;i--)
        {
            if(Address != validater_info[i].validater){
                validater[Address][id] = validater_info[i].validater;
                break;
            }
        }
    }
   
    function get_reward(address Address,uint id) public {
        uint n = role[Address][id];
        if(n==1){
            if(ans[Address][id]){
               RToken.transfer(Address,5);
               unstakeTokens(Address, id);
            }
            else{
                blacklisted[Address] = true;
            }
        }
        if(n==2){
            if(ans[Address][id]){
                RToken.transfer(Address,3);
            }
            else{
                blacklisted[Address] = true;
            }
        }
        if(n==3){
            if(ans[Address][id]){
                uint duration = prog.get_duration(Address,id);
                uint p = duration * 1;
                RToken.transfer(Address,p);
            }
            else{
                 blacklisted[Address] = true;
            }
        }
        check_validater(Address);
    }
   
    function stakeTokens(address Address, uint program_id, uint _amount) public {
        BToken.transferFrom(Address, address(this), _amount);
        stakingBalance[Address][program_id] = stakingBalance[Address][program_id] + _amount;
    }
   
    function unstakeTokens(address Address, uint program_id) public {
        uint balance = stakingBalance[Address][program_id];
        require(balance > 0, "staking balance cannot be 0");
        BToken.transfer(Address, balance);
        stakingBalance[Address][program_id] = 0;
    }
   
    function toservice(address to, uint id, uint amount) public{
        require(amount<=DonationReceived[id],"insufficient amount");
        BToken.transferFrom(address(this),to,amount);
        DonationReceived[id]=DonationReceived[id]-amount;
    }
}
