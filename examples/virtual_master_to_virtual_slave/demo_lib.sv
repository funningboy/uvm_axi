
// testsuite select ....

class Demo_base_test extends uvm_test;

  `uvm_component_utils_begin(Demo_base_test)
  `uvm_component_utils_end

  Demo_tb m_demo_tb;
  uvm_table_printer m_printer;


  function new(string name = "demo_base_test", uvm_component parent);
    super.new(name,parent);
    m_printer = new();
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_demo_tb = Demo_tb::type_id::create("m_demo_tb", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    m_printer.knobs.depth = 5;
    this.print(m_printer);
    uvm_report_object::set_report_max_quit_count(2); // set max error quit counts
    phase.phase_done.set_drain_time(this, 1000);
  endtask : run_phase

endclass : Demo_base_test


//-----------------------------------------------------
// TEST: Test_write_data_after_write_addr
//-----------------------------------------------------
class Test_write_data_after_write_addr extends Demo_base_test;

  `uvm_component_utils(Test_write_data_after_write_addr)

  function new(string name = "Test_write_data_after_write_addr", uvm_component parent);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    uvm_config_db #(uvm_object_wrapper)::set(this, "m_demo_tb.m_axi_env.m_masters[0].m_sequencer.run_phase",
                          "default_sequence", DEMO_AXI_master_write_data_after_write_addr::type_id::get());

   super.build_phase(phase);
  endfunction : build_phase

endclass : Test_write_data_after_write_addr


//-----------------------------------------------------
// TEST: Test_write_addr_after_write_data
//-----------------------------------------------------
class Test_write_addr_after_write_data extends Demo_base_test;

  `uvm_component_utils(Test_write_addr_after_write_data)

  function new(string name = "Test_write_addr_after_write_data", uvm_component parent);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    uvm_config_db #(uvm_object_wrapper)::set(this, "m_demo_tb.m_axi_env.m_masters[0].m_sequencer.run_phase",
                          "default_sequence", DEMO_AXI_master_write_addr_after_write_data::type_id::get());

   super.build_phase(phase);
  endfunction : build_phase

endclass : Test_write_addr_after_write_data

//-----------------------------------------------------
// TEST: Test_write_out_of_performance
//-----------------------------------------------------
class Test_write_out_of_performance extends Demo_base_test;

  `uvm_component_utils(Test_write_out_of_performance)

  function new(string name = "Test_write_out_of_performance", uvm_component parent);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    uvm_config_db #(uvm_object_wrapper)::set(this, "m_demo_tb.m_axi_env.m_masters[0].m_sequencer.run_phase",
                          "default_sequence", DEMO_AXI_master_write_out_of_performance::type_id::get());

   super.build_phase(phase);
  endfunction : build_phase

endclass : Test_write_out_of_performance


//-----------------------------------------------------
// TEST: Test_read_out_of_performance
//-----------------------------------------------------
class Test_read_out_of_performance extends Demo_base_test;

  `uvm_component_utils(Test_read_out_of_performance)

  function new(string name = "Test_read_out_of_performance", uvm_component parent);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    uvm_config_db #(uvm_object_wrapper)::set(this, "m_demo_tb.m_axi_env.m_masters[0].m_sequencer.run_phase",
                          "default_sequence", DEMO_AXI_master_read_out_of_performance::type_id::get());

   super.build_phase(phase);
  endfunction : build_phase

endclass : Test_read_out_of_performance


//-----------------------------------------------------
// TEST: Test_out_of_order_seqs
//-----------------------------------------------------
