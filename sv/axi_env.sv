
/*--------------------------------------
// AXI env
// file : axi_env.sv
// author : SeanChen
// date : 2013/05/06
// description : define how many master/slave and connection,,,
---------------------------------------*/

`ifndef AXI_ENV_SV
`define AXI_EMV_SV

class AXI_env extends uvm_env;

  AXI_env_conf  m_env_conf;

  bit checks_enable = 1;
  bit coverage_enable = 1;

  AXI_master_agent  m_masters[];
  AXI_slave_agent   m_slaves[];

  `uvm_component_utils_begin(AXI_env)
    `uvm_field_object       (m_env_conf,        UVM_DEFAULT)
    `uvm_field_int          (checks_enable,     UVM_DEFAULT)
    `uvm_field_int          (coverage_enable,   UVM_DEFAULT)
    `uvm_field_array_object (m_masters,         UVM_DEFAULT)
    `uvm_field_array_object (m_slaves,          UVM_DEFAULT)
  `uvm_component_utils_end


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new


  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);

  extern virtual function void assign_conf(AXI_env_conf conf);

  extern virtual function void build_masters();
  extern virtual function void build_slaves();

endclass : AXI_env


function void AXI_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (m_env_conf == null)
     `uvm_error("NOCONF",{ "AXI ENV conf"} )

  build_masters();
  build_slaves();
  assign_conf(m_env_conf);

endfunction : build_phase


function void AXI_env::build_masters();

  m_masters = new[m_env_conf.m_master_confs.size()];

  for(int i=0; i < m_env_conf.m_master_confs.size(); i++) begin
    m_masters[i] = AXI_master_agent::type_id::create($psprintf("m_masters[%0d]", i), this);
    m_masters[i].assign_conf(m_env_conf.m_master_confs[i]);
  end

endfunction : build_masters


function void AXI_env::build_slaves();

   m_slaves  = new[m_env_conf.m_slave_confs.size()];

  for(int i=0; i < m_env_conf.m_slave_confs.size(); i++) begin
    m_slaves[i] = AXI_slave_agent::type_id::create($psprintf("m_slaves[%0d]", i), this);
    m_slaves[i].assign_conf(m_env_conf.m_slave_confs[i]);
  end

endfunction : build_slaves


// UVM start_of_simulation_phase
function void AXI_env::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase


function void AXI_env::assign_conf(AXI_env_conf conf);
  m_env_conf = conf;
endfunction : assign_conf

`endif // AXI_ENV_SV
