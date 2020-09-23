pragma solidity ^0.5.0;

contract program{
    
    struct Proof_Program{
        address manager_id;
        string descrption;
        string mail_id;
        string contact_details;
    }
    
    mapping(uint => Proof_Program) public program_proof;
    
    struct Volunteer{
        address id;
        string Name;
        string job_title;
        string Contact_Details;
        string mail_id;
    }
    
    mapping(address => mapping(uint => Volunteer)) public volunteer;
    
     struct Proof_Volunteer{
        address id;
        string work_by_volunteer;
        uint duration;
        string descrption;
        string mail_id;
        string contact_Details;
    }
    
    mapping(address => mapping (uint => Proof_Volunteer)) public volunteer_proof;
    
    struct ServiceProvider{
        address id;
        string Name;
        string job_title;
        string Contact_Details;
        string mail_id;
    }
    
    mapping(address => mapping(uint => ServiceProvider)) public serviceprovider;
    
    struct Proof_Provider{
        address id;
        string provided_service;
        string descrption;
        string mail_id;
        string contact_details;
    }
    
     mapping(address => mapping (uint => Proof_Provider)) public provider_proof;
     
    struct Create_Program{
        address manager_id;
        string manager_name;
        uint project_id;
        uint Fund_needed;
        uint Duration;
        string descrption;
        string mail_id;
    }
    mapping(uint =>Create_Program) public program_info;
    
    function Program_detail(address Address,string memory name,uint project_count,uint Fund_needed, uint duration, string memory descrption,string memory email) public{
        program_info[project_count] = Create_Program(Address,name,project_count, Fund_needed, duration,descrption,email);
    }
    
    
    function completion_proof(address Address,uint program_id,string memory descrption, string memory mail_id, string memory contact_details) public{
        program_proof[program_id] = Proof_Program(Address, descrption, mail_id, contact_details);
    }
    
    function Fund_details(uint id) public view returns(uint){
        return(program_info[id].Fund_needed);
    }
    
    function Manager_Id(uint id) public view returns(address){
        return(program_info[id].manager_id);
    }
    
    function Volunteer_info(address Address,string memory name,string memory title,string memory contact_details, string memory email, uint program_id) public {
        volunteer[Address][program_id] = Volunteer(Address,name,title,contact_details,email);
    }
    
    function volunteerproof_Info(address Address,string memory work_by_volunteer,uint program_id, uint duration, string memory description,
    string memory email, string memory contact) public{
        volunteer_proof[Address][program_id] = Proof_Volunteer(Address, work_by_volunteer,duration,description,
        email, contact);
    }
    
    function get_duration(address Address,uint prg_id) public view returns(uint){
        return volunteer_proof[Address][prg_id].duration;
    }
    
    function ServiceProvider_Info(address Address,string memory name,string memory title,string memory contact_details, string memory email, uint program_id) public{
        serviceprovider[Address][program_id] = ServiceProvider(Address,name,title,contact_details,email);
    }
    
    function serviceproof_info(address Address,uint program_id,string memory provided_service, string memory descrption, 
    string memory mail_id, string memory contact_details) public{
        provider_proof[Address][program_id] = Proof_Provider(Address, provided_service, descrption,mail_id, contact_details);
    }
}
    