/*--------------------------------------
// AXI PKG
// file : axi_pkg.sv
// author : SeanChen
// date : 2013/05/06
// notes
---------------------------------------*/

`ifndef AXI_PKG_SV
`define AXI_PKG_SV

package axi_pkg;

// Import the UVM class library  and UVM automation macros
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "axi_type.sv"
`include "axi_conf.sv"
`include "axi_transfer.sv"
`include "axi_common.sv"

`include "axi_master_monitor.sv"
`include "axi_master_driver.sv"
`include "axi_master_sequencer.sv"
//`include "axi_master_recorder.sv"
`include "axi_master_agent.sv"

`include "axi_slave_monitor.sv"
`include "axi_slave_driver.sv"
`include "axi_slave_sequencer.sv"
`include "axi_slave_agent.sv"

`include "axi_env.sv"

endpackage : axi_pkg
`endif  // AXI_PKG_SV
