
`ifndef DEMO_AXI_SLAVE_SEQ_LIB_SV
`define DEMO_AXI_SLAVE_SEQ_LIB_SV

class DEMO_AXI_slave_monitor extends AXI_slave_base_seq;

  function new(string name="demo_axi_slave_monitor");
    super.new(name);
    `uvm_info(get_type_name(), "xxxxxxxx", UVM_MEDIUM)
  endfunction

  `uvm_object_utils_begin(DEMO_AXI_slave_monitor)
  `uvm_object_utils_end

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
  endtask

endclass : DEMO_AXI_slave_monitor

`endif // DEMO_AXI_SLAVE_SEQ_LIB_SV

