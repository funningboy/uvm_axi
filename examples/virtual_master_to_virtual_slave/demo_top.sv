
`include "axi_vif.sv"
`include "axi_pkg.sv"
`include "axi_seq_lib_pkg.sv"
`include "demo_pkg.sv"
`include "dut_dummy.v"

module demo_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import axi_pkg::*;
  import demo_pkg::*;

  reg clock;
  reg reset;

  AXI_vif axi_vif_0(
                    .AXI_ACLK(clock),
                    .AXI_ARESET_N(reset)
  );

  // assign vif axi_vif_0 to pin connect
  dut_dummy dut( .clock(clock),
                 .reset(reset)
               );

  // popular the vif to each sub own leafs...
  // wake up our test ....
  initial begin
    uvm_config_db#(virtual interface AXI_vif)::set(uvm_root::get(), "*", "m_vif", axi_vif_0);
    run_test();
  end

  initial begin
    $dumpfile("demo_tb.vcd");
    $dumpvars(3, demo_top);
  end

  initial begin
    reset = 1'b1;
    clock = 1'b0;
    #20 reset = 1'b0;
    #20 reset = 1'b1;
  end

  // init memory vpi
  initial begin
    #1 $mem_init(0,"demo.bin");
  end

  //Generate Clock
  always
    #5 clock = ~clock;

endmodule
