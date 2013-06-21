`ifndef DEMO_SCOREBOARD_SV
`define DEMO_SCOREBOARD_SV

`include "axi_transfer.sv"

class Demo_scoreboard extends uvm_scoreboard;

  uvm_analysis_imp#(AXI_transfer, Demo_scoreboard) item_collected_imp;

  protected bit disable_scoreboard = 0;
  protected int m_num_writes       = 0;
  protected int m_num_reads        = 0;

  int unsigned m_mem_expected[int unsigned];

  `uvm_component_utils_begin(Demo_scoreboard)
    `uvm_field_int  (disable_scoreboard,  UVM_ALL_ON)
    `uvm_field_int  (m_num_writes,        UVM_ALL_ON|UVM_DEC)
    `uvm_field_int  (m_num_reads,         UVM_ALL_ON|UVM_DEC)
  `uvm_component_utils_end

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Construct the TLM interface
    item_collected_imp = new("item_collected_imp", this);
  endfunction : new

  // Additional class methods
  extern virtual function void write(AXI_transfer trx);
//  extern virtual function void report();

  extern virtual function void memory_verify(AXI_transfer trx);
  extern virtual function void connect_verify(AXI_transfer trx);

endclass : Demo_scoreboard


// TLM write() implementation
function void Demo_scoreboard::write(AXI_transfer trx);

  if(!disable_scoreboard) begin
    `uvm_info(get_type_name(), $psprintf("Scoreboard \n%s", trx.sprint()), UVM_HIGH)

    memory_verify(trx);
    connect_verify(trx);
    // others ...
  end
endfunction : write

// connect verify
function void Demo_scoreboard::connect_verify(AXI_transfer trx);
endfunction : connect_verify


// memory verify
function void Demo_scoreboard::memory_verify(AXI_transfer trx);

  for (int unsigned i=0; i<trx.mem_addrs.size(); i++) begin

    if (trx.rw == WRITE && trx.itype == SLAVE) begin

      if (m_mem_expected.exists(trx.mem_addrs[i]))
        `uvm_error("NOEXPECT", {($psprintf("%s over write at address %h ",  get_full_name(), trx.mem_addrs[i]))})

      m_mem_expected[trx.mem_addrs[i]] = trx.data[i];

    end else if (trx.rw == READ && trx.itype == SLAVE) begin

      if (!m_mem_expected.exists(trx.mem_addrs[i])) begin
        `uvm_error("NOEXPECT", {($psprintf("%s read null at address %h ",  get_full_name(), trx.mem_addrs[i]))})

      end else begin
         if (m_mem_expected[trx.mem_addrs[i]] != trx.data[i])
          `uvm_error("NOEXPECT", {($psprintf("%s read %h not foud at address %h ",  get_full_name(), trx.data[i], trx.mem_addrs[i]))})

      end
    end
  end

endfunction : memory_verify


`endif // DEMO_SCOREBOARD_SV
