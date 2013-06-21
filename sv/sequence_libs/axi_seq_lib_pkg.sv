/*--------------------------------------
// AXI SEQ LIB PKG
// file : axi_pkg.sv
// author : SeanChen
// date : 2013/05/06
// notes
---------------------------------------*/


`ifndef AXI_SEQ_LIB_PKG_SV
`define AXI_SEQ_LIB_PKG_SV

package axi_seq_lib_pkg;

// Import the UVM class library  and UVM automation macros
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "axi_pkg.sv"
import axi_pkg::*;

`include "axi_based_seq_lib.sv"
`include "axi_master_based_seq_lib.sv"
`include "axi_slave_based_seq_lib.sv"
`include "axi_master_read_seq_lib.sv"
`include "axi_master_write_seq_lib.sv"

endpackage : axi_seq_lib_pkg

`endif  // AXI_SEQ_LIB_PKG_SV
