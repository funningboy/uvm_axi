
// define connection and platform struct

`ifndef DEMO_TB_SV
`define DEMO_TB_SV

class Demo_tb extends uvm_env;

  `uvm_component_utils_begin(Demo_tb)
  `uvm_component_utils_end

   AXI_env          m_axi_env;
   Demo_scoreboard  m_demo_scoreboard;
   Demo_conf        m_demo_conf;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : Demo_tb

// set up conf to sub leaf masters/slaves
function void Demo_tb::build_phase(uvm_phase phase);
  super.build_phase(phase);
  m_demo_conf       = Demo_conf::type_id::create("m_demo_conf", this);
  m_demo_scoreboard = Demo_scoreboard::type_id::create("m_demo_scoreboard", this);
  m_axi_env         = AXI_env::type_id::create("m_axi_env", this);
  m_axi_env.assign_conf(m_demo_conf);

endfunction : build_phase

// TLM analysis port from master/slave monitor to scoreboard
function void Demo_tb::connect_phase(uvm_phase phase);
  m_axi_env.m_masters[0].m_monitor.item_collected_port.connect(m_demo_scoreboard.item_collected_imp);
  m_axi_env.m_slaves[0].m_monitor.item_collected_port.connect(m_demo_scoreboard.item_collected_imp);
endfunction : connect_phase

`endif // DEMO_TB_SV
