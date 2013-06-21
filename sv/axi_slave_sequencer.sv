/*--------------------------------------
// AXI slave sequencer
// file : axi_slave_sequencer.sv
// author : SeanChen
// date : 2013/05/06
// description : it's a driver bridge
---------------------------------------*/

`ifndef AXI_SLAVE_SEQUENCER_SV
`define AXI_SLAVE_SEQUENCER_SV

class AXI_slave_sequencer extends uvm_sequencer #(AXI_transfer);

  `uvm_component_utils_begin(AXI_slave_sequencer)
  `uvm_component_utils_end

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : AXI_slave_sequencer

`endif // AXI_slave_sequencer
