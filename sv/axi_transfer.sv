
/*--------------------------------------
// AXI transfer
// file : axi_transfer.sv
// author : SeanChen
// date : 2013/05/06
// description: based AXT transfer type (TLM info struct)
---------------------------------------*/

`ifndef AXI_TRANSFER_SV
`define AXI_TRANSFER_SV

class AXI_base extends uvm_sequence_item;

	rand int unsigned id;
  rand int unsigned transmit_delay = 0;
  rand int unsigned addr_wt_delay  = 0;
  rand int unsigned data_wt_delay  = 0;
  rand int unsigned resp_wt_delay  = 0;
  rand int unsigned addr_rd_delay  = 0;
  rand int unsigned data_rd_delay  = 0;

  rand int unsigned data_bytes     = 4;
  rand int unsigned half_cycle     = 0;

  rand longint  begin_cycle        = 0;
  rand longint  end_cycle          = 0;

  rand longint  begin_time         = 0;
  rand longint  end_time           = 0;

  rand longint  used_cycle         = 0;

	string            master = "";
  string            slave  = "";

  int unsigned      records[$]; // record router paths from master to slave

  constraint c_transmit_delay { 1 <= transmit_delay <= 10; }
  constraint c_addr_wt_delay  { 1 <= addr_wt_delay  <= 10; }
  constraint c_data_wt_delay  { 1 <= data_wt_delay  <= 10; }
  constraint c_resp_wt_delay  { 1 <= resp_wt_delay  <= 10; }
  constraint c_addr_rd_delay  { 1 <= addr_rd_delay  <= 10; }
  constraint c_data_rd_delay  { 1 <= data_rd_delay  <= 10; }

  `uvm_object_utils_begin(AXI_base)
    `uvm_field_int  (id,              UVM_DEFAULT)
    `uvm_field_int  (transmit_delay,  UVM_DEFAULT)
    `uvm_field_int  (addr_wt_delay,   UVM_DEFAULT)
    `uvm_field_int  (data_wt_delay,   UVM_DEFAULT)
    `uvm_field_int  (resp_wt_delay,   UVM_DEFAULT)
    `uvm_field_int  (addr_rd_delay,   UVM_DEFAULT)
    `uvm_field_int  (data_rd_delay,   UVM_DEFAULT)
    `uvm_field_queue_int (records,    UVM_DEFAULT)
    `uvm_field_int  (data_bytes,      UVM_DEFAULT)
    `uvm_field_int  (half_cycle,      UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "axi_base");
    super.new(name);
  endfunction

endclass : AXI_base


class AXI_transfer extends AXI_base;

  rand itype_enum       itype;
  rand direction_enum   rw;
	rand int unsigned     addr;
  rand int unsigned     region;
	rand len_enum 	      len;
  rand byte_enum        size;
  rand burst_enum       burst;
  rand lock_enum        lock;
  rand cache_enc_enum   cache;
  rand protect_enc_enum prot;
  rand int unsigned     qos;
  rand int unsigned     strb[$];
  rand response_enum    resp;
	rand int unsigned     data[$];

  rand bit              addr_done;
  rand bit              data_done;

  rand int unsigned     mem_datas[$];
  rand int unsigned     mem_addrs[$];

  `uvm_object_utils_begin(AXI_transfer)
    `uvm_field_enum (itype_enum, itype,   UVM_DEFAULT)
    `uvm_field_enum (direction_enum, rw,  UVM_DEFAULT)
    `uvm_field_int  (addr,                UVM_DEFAULT)
    `uvm_field_int  (region,              UVM_DEFAULT)
    `uvm_field_enum (len_enum, len,       UVM_DEFAULT)
    `uvm_field_enum (byte_enum, size,     UVM_DEFAULT)
    `uvm_field_enum (burst_enum, burst,   UVM_DEFAULT)
    `uvm_field_enum (lock_enum, lock,     UVM_DEFAULT)
    `uvm_field_enum (cache_enc_enum, cache, UVM_DEFAULT)
    `uvm_field_enum (protect_enc_enum, prot, UVM_DEFAULT)
    `uvm_field_int  (qos,                 UVM_DEFAULT)
    `uvm_field_queue_int(strb,                UVM_DEFAULT)
    `uvm_field_enum (response_enum, resp, UVM_DEFAULT)
    `uvm_field_queue_int(data,            UVM_DEFAULT)
    `uvm_field_int  (addr_done,           UVM_DEFAULT)
    `uvm_field_int  (data_done,           UVM_DEFAULT)
    `uvm_field_queue_int(mem_datas,       UVM_DEFAULT)
    `uvm_field_queue_int(mem_addrs,       UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "axi_transfer");
    super.new(name);
  endfunction

endclass : AXI_transfer


`endif // AXI_TRANSFER_SV


