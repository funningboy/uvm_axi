/*--------------------------------------
// AXI slave driver
// file : axi_slave_driver.sv
// author : SeanChen
// date : 2013/05/06
// brief : slave driver, transfer TLM level info to pin level info
---------------------------------------*/

`ifndef AXI_slave_DRIVER_SV
`define AXI_slave_DRIVER_SV

class AXI_slave_driver extends uvm_driver #(AXI_transfer);

  virtual interface AXI_vif   m_vif;
  AXI_slave_conf              m_conf;

  int unsigned                m_num_sent;

  AXI_transfer                m_wr_queue[$];
  AXI_transfer                m_rd_queue[$];

  int unsigned                m_mem[int unsigned];

  uvm_analysis_imp#(AXI_transfer, AXI_slave_driver) item_write_imp;
  uvm_analysis_imp#(AXI_transfer, AXI_slave_driver) item_read_imp;

	// reserve fields
	`uvm_component_utils_begin(AXI_slave_driver)
		`uvm_field_int		   (m_num_sent,			UVM_ALL_ON)
	`uvm_component_utils_end

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);

    // TLM
    item_write_imp = new("item_write_imp", this);
    item_read_imp = new("item_read_imp", this);

  endfunction : new

  // Additional class methods
  extern virtual function void assign_vi(virtual interface AXI_vif vif);
  extern virtual function void assign_conf(AXI_slave_conf conf);

  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive();
  extern virtual protected task reset_signals();
  extern virtual protected task drive_transfer();
 // extern virtual function void report();

  extern virtual protected task sent_addr_write_trx();
  extern virtual protected task sent_data_write_trx();
  extern virtual protected task sent_resp_write_trx();

  extern virtual protected task sent_addr_read_trx();
  extern virtual protected task sent_data_read_trx();

  extern virtual protected task wait_for_reset();
  extern virtual protected task sent_trx_to_seq();

  // TLM analsis port call back
  extern virtual function void write(AXI_transfer trx);

//  extern virtual protected task
endclass : AXI_slave_driver


function void AXI_slave_driver::assign_vi(virtual interface AXI_vif vif);
  m_vif = vif;
endfunction


function void AXI_slave_driver::assign_conf(AXI_slave_conf conf);
  m_conf = conf;
endfunction


//UVM connect_phase
function void AXI_slave_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (!uvm_config_db#(virtual interface AXI_vif)::get(this, "", "m_vif", m_vif))
   `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".m_vif"})

  assert(m_conf!=null);
//  if (!uvm_config_db#(AXI_slave_conf)::get(this, "", "m_conf", m_conf))
//    `uvm_error("NOCONF",{"axi conf must be set for: ", get_full_name(), ".m_conf"})

endfunction : connect_phase


// UVM run() phase
task AXI_slave_driver::run_phase(uvm_phase phase);
    fork
      get_and_drive();
      reset_signals();
    join
endtask : run_phase


// Gets transfers from the sequencer and passes them to the driver.
task AXI_slave_driver::get_and_drive();
    wait_for_reset();
    sent_trx_to_seq();
endtask : get_and_drive


// Reset all slave signals
task AXI_slave_driver::reset_signals();
    forever begin
      @(posedge m_vif.AXI_ARESET_N);
      `uvm_info(get_type_name(), "Reset observed", UVM_MEDIUM)
        // addr write
        m_vif.AXI_AWREADY <= 0;
        // data write
        m_vif.AXI_WREADY  <= 0;
        // resp write
        m_vif.AXI_BID     <= 0;
        // ....
    end
endtask : reset_signals


task AXI_slave_driver::wait_for_reset();
    wait(!m_vif.AXI_ARESET_N)
    `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)

endtask : wait_for_reset


// get next trx when reset has already done
// default : set init memory map
task AXI_slave_driver::sent_trx_to_seq();
  drive_transfer();
endtask : sent_trx_to_seq


// Gets a transfer and drive it into the DUT
// ps addr_write and data_write can be the same time
task AXI_slave_driver::drive_transfer();
  fork
    sent_addr_read_trx();
    sent_data_read_trx();

    sent_addr_write_trx();
    sent_data_write_trx();
    sent_resp_write_trx();
  join
endtask : drive_transfer


// sent addr write trx
task AXI_slave_driver::sent_addr_write_trx();

  forever begin
    `delay(m_conf.half_cycle);
    m_vif.AXI_AWREADY <= 1'b0;
    repeat($urandom_range(4,8)) @(posedge m_vif.AXI_ACLK);

    `delay(m_conf.half_cycle);
    m_vif.AXI_AWREADY <= 1'b1;
    @(posedge m_vif.AXI_ACLK);

    // hold until AWVALID received
    while(!m_vif.AXI_AWVALID) @(posedge m_vif.AXI_ACLK);
  end

endtask : sent_addr_write_trx


// sent data write trx
task AXI_slave_driver::sent_data_write_trx();

  forever begin
    `delay(m_conf.half_cycle);
    m_vif.AXI_WREADY <= 1'b0;
    repeat($urandom_range(4,8)) @(posedge m_vif.AXI_ACLK);

    `delay(m_conf.half_cycle);
    m_vif.AXI_WREADY <= 1'b1;
    @(posedge m_vif.AXI_ACLK);

    // hold until WVALID received
    while(!m_vif.AXI_WVALID) @(posedge m_vif.AXI_ACLK);

    // continuous hold cycle for burst case
    `delay(m_conf.half_cycle);
    m_vif.AXI_WREADY <= 1'b1;
    repeat($urandom_range(4,16)) @(posedge m_vif.AXI_ACLK);
  end

endtask : sent_data_write_trx


// sent data resp trx collected resp to trx
// return priority is based by Qos
task AXI_slave_driver::sent_resp_write_trx();
  AXI_transfer t_trx;

  forever begin

    repeat(m_wr_queue.size()==0) @(posedge m_vif.AXI_ACLK);

    if (m_wr_queue.size()!=0) begin
      t_trx = m_wr_queue[0];

      repeat(t_trx.resp_wt_delay)@(posedge m_vif.AXI_ACLK);

      // sent trx
      `delay(m_conf.half_cycle);
      m_vif.AXI_BVALID <= 1'b1;
      m_vif.AXI_BID    <= t_trx.id;
      m_vif.AXI_BRESP  <= OKAY;
      @(posedge m_vif.AXI_ACLK);

      // hold until BREADY received
      while(!m_vif.AXI_BREADY) @(posedge m_vif.AXI_ACLK);
      void'(m_wr_queue.pop_front());

      // free trx
      `delay(m_conf.half_cycle);
      m_vif.AXI_BVALID <= 1'b0;
      @(posedge m_vif.AXI_ACLK);

    end
  end

endtask : sent_resp_write_trx


// sent addr read trx
task AXI_slave_driver::sent_addr_read_trx();

  forever begin
    `delay(m_conf.half_cycle);
    m_vif.AXI_ARREADY <= 1'b0;
    repeat($urandom_range(4,8)) @(posedge m_vif.AXI_ACLK);

    `delay(m_conf.half_cycle);
    m_vif.AXI_ARREADY <= 1'b1;
    @(posedge m_vif.AXI_ACLK);

    // hold until ARVALID received
    while(!m_vif.AXI_ARVALID) @(posedge m_vif.AXI_ACLK);
  end

endtask : sent_addr_read_trx


// sent data read trx
task AXI_slave_driver::sent_data_read_trx();
  AXI_transfer t_trx;
  int unsigned i = 0;

  forever begin

    repeat(m_rd_queue.size()==0) @(posedge m_vif.AXI_ACLK);

    if (m_rd_queue.size()!=0) begin
        t_trx = m_rd_queue[0];
        i = 0;

        repeat(m_conf.data_rd_delay) @(posedge m_vif.AXI_ACLK);

         // sent trx
         while (i!=t_trx.len+1) begin

             `delay(m_conf.half_cycle);
             m_vif.AXI_RVALID  <= 1'b1;
             m_vif.AXI_RDATA   <= m_mem[t_trx.mem_addrs[i]];
             m_vif.AXI_RID     <= t_trx.id;
             m_vif.AXI_RRESP   <= OKAY;
             m_vif.AXI_RLAST   <= (i==t_trx.len)? 1'b1 : 1'b0;
             @(posedge m_vif.AXI_ACLK);

             if (m_vif.AXI_RREADY && m_vif.AXI_RVALID)
               i = i+1;
         end

         // hold until finsih

         // free trx
         void'(m_rd_queue.pop_front());

        `delay(m_conf.half_cycle);
        m_vif.AXI_RVALID <= 1'b0;
        m_vif.AXI_RLAST  <= 1'b0;
        @(posedge m_vif.AXI_ACLK);

      end
  end

endtask : sent_data_read_trx


// TLM analysis port
function void AXI_slave_driver::write(AXI_transfer trx);

    if (trx.rw == WRITE && trx.itype == SLAVE) begin
      m_wr_queue.push_back(trx);

      foreach (trx.mem_addrs[i]) begin
          m_mem[trx.mem_addrs[i]] = trx.data[i];
      end

    end else if (trx.rw == READ && trx.itype == SLAVE) begin
      m_rd_queue.push_back(trx);
    end

endfunction : write

`endif // AXI_slave_DRIVER_SV


