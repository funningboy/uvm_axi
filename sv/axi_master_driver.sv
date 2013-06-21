/*--------------------------------------
// AXI master driver
// file : axi_master_driver.sv
// author : SeanChen
// date : 2013/05/06
// brief : master driver, transfer TLM level info to pin level info
---------------------------------------*/

`ifndef AXI_MASTER_DRIVER_SV
`define AXI_MASTER_DRIVER_SV

class AXI_master_driver extends uvm_driver #(AXI_transfer);

  virtual interface AXI_vif   m_vif;
  AXI_master_conf             m_conf;
  AXI_transfer                m_wr_queue[$];
  AXI_transfer                m_rd_queue[$];
  int unsigned                m_num_sent;

  event                       event_sent_write_trx;
  event                       event_sent_read_trx;

  int unsigned                m_wr_addr_indx = 0;
  int unsigned                m_wr_data_indx = 0;

  int unsigned                m_rd_addr_indx = 0;

	// reserve fields
	`uvm_component_utils_begin(AXI_master_driver)
		`uvm_field_int		(m_num_sent,			UVM_ALL_ON)
	`uvm_component_utils_end

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional class methods
  extern virtual function void assign_vi(virtual interface AXI_vif vif);
  extern virtual function void assign_conf(AXI_master_conf conf);

  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive();
  extern virtual protected task reset_signals();
  extern virtual protected task drive_transfer(AXI_transfer trx);
 // extern virtual function void report();

  extern virtual task sent_addr_write_trx();
  extern virtual task sent_data_write_trx();
  extern virtual task received_resp_write_trx();

  extern virtual task sent_addr_read_trx();
  extern virtual task received_data_read_trx();

  extern virtual task free_write_trx();
  extern virtual task free_read_trx();

  extern virtual protected task wait_for_reset();
  extern virtual protected task sent_trx_to_seq();

endclass : AXI_master_driver


function void AXI_master_driver::assign_vi(virtual interface AXI_vif vif);
  m_vif = vif;
endfunction


function void AXI_master_driver::assign_conf(AXI_master_conf conf);
  m_conf = conf;
endfunction


//UVM connect_phase
function void AXI_master_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (!uvm_config_db#(virtual interface AXI_vif)::get(this, "", "m_vif", m_vif))
   `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".m_vif"})

  assert(m_conf!=null);
//  if (!uvm_config_db#(AXI_master_conf)::get(this, "", "m_conf", m_conf))
//    `uvm_error("NOCONF",{"axi conf must be set for: ", get_full_name(), ".m_conf"})

endfunction : connect_phase


// UVM run() phase spawn sub events
task AXI_master_driver::run_phase(uvm_phase phase);
    fork
      get_and_drive();
      reset_signals();
      sent_addr_write_trx();
      sent_data_write_trx();
      received_resp_write_trx();
      sent_addr_read_trx();
      received_data_read_trx();
      free_write_trx();
      free_read_trx();
    join
endtask : run_phase


// Gets transfers from the sequencer and passes them to the driver.
task AXI_master_driver::get_and_drive();
    wait_for_reset();
    sent_trx_to_seq();
endtask : get_and_drive


// Reset all master signals
task AXI_master_driver::reset_signals();
    forever begin
      @(posedge m_vif.AXI_ARESET_N);
      `uvm_info(get_type_name(), "Reset observed", UVM_MEDIUM)
        m_vif.AXI_AWID   <= 0;
        m_vif.AXI_AWADDR <= 0;
        // ....
    end
endtask : reset_signals


task AXI_master_driver::wait_for_reset();
    @(posedge m_vif.AXI_ARESET_N)
    `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)

endtask : wait_for_reset


// get next trx when reset has already done
task AXI_master_driver::sent_trx_to_seq();
     forever begin
        @(posedge m_vif.AXI_ACLK);
        seq_item_port.get_next_item(req);
        drive_transfer(req);
        seq_item_port.item_done();
    end
endtask : sent_trx_to_seq


// free write trx
task AXI_master_driver::free_write_trx();

endtask : free_write_trx

// free read trx
task AXI_master_driver::free_read_trx();

endtask : free_read_trx


// Gets a transfer and drive it into the DUT
// push the trx to trx async queue
task AXI_master_driver::drive_transfer(AXI_transfer trx);

    `uvm_info(get_type_name(), $psprintf("Driving \n%s", trx.sprint()), UVM_HIGH)

    if (trx.rw == READ) begin
        m_rd_queue.push_back(trx);

    end else if (trx.rw == WRITE) begin
        m_wr_queue.push_back(trx);

    end else begin
      `uvm_error("NOTYPE",{"type not support"})
    end

    m_num_sent++;
    `uvm_info(get_type_name(), $psprintf("Item %0d Sent ...", m_num_sent), UVM_HIGH)

endtask : drive_transfer


// addr write trx task by event_sent_write_trx.trigger
task AXI_master_driver::sent_addr_write_trx();
    AXI_transfer m_trx;

    forever begin
      // if write trx has existed...
      repeat(m_wr_queue.size()==0) @(posedge m_vif.AXI_ACLK);

      if (m_wr_addr_indx < m_wr_queue.size()) begin
          m_trx = m_wr_queue[m_wr_addr_indx];

          repeat(m_trx.addr_wt_delay) @(posedge m_vif.AXI_ACLK);

          // sent trx
          `delay(m_conf.half_cycle);
          m_vif.AXI_AWVALID <= 1'b1;
          m_vif.AXI_AWID    <= m_trx.id;
          m_vif.AXI_AWADDR  <= m_trx.addr;
          m_vif.AXI_AWREG   <= m_trx.region;
          m_vif.AXI_AWLEN   <= m_trx.len;
          m_vif.AXI_AWSIZE  <= m_trx.size;
          m_vif.AXI_AWBURST <= m_trx.burst;
          m_vif.AXI_AWLOCK  <= m_trx.lock;
          m_vif.AXI_AWCACHE <= m_trx.cache;
          m_vif.AXI_AWPROT  <= m_trx.prot;
          m_vif.AXI_AWQOS   <= m_trx.qos;
          @(posedge m_vif.AXI_ACLK);

          // hold until AWREADY received
          while (!m_vif.AXI_AWREADY) @(posedge m_vif.AXI_ACLK);

          // free trx
          `delay(m_conf.half_cycle);
          m_vif.AXI_AWVALID <= 1'b0;
          m_trx.addr_done = `TRUE;
          @(posedge m_vif.AXI_ACLK);

          m_wr_addr_indx += 1;

      end else begin
        @(posedge m_vif.AXI_ACLK);
      end
    end

endtask : sent_addr_write_trx


// data write trx task by event_sent_write_trx.trigger
task AXI_master_driver::sent_data_write_trx();
    int unsigned  i = 0;
    AXI_transfer  m_trx;

    forever begin

      repeat(m_wr_queue.size()==0) @(posedge m_vif.AXI_ACLK);

      if (m_wr_data_indx < m_wr_queue.size()) begin
          m_trx = m_wr_queue[m_wr_data_indx];

          repeat(m_trx.data_wt_delay) @(posedge m_vif.AXI_ACLK);

          // sent trx
          while (i<=m_trx.len) begin

            `delay(m_conf.half_cycle);
            m_vif.AXI_WVALID  <= 1'b1;
            m_vif.AXI_WDATA   <= m_trx.data[i];
            m_vif.AXI_WSTRB   <= m_trx.strb[i];
            m_vif.AXI_WID     <= m_trx.id;
            m_vif.AXI_WLAST   <= (i==m_trx.len)? 1'b1 : 1'b0;
            @(posedge m_vif.AXI_ACLK);

            if (m_vif.AXI_WREADY && m_vif.AXI_WVALID)
              i = i+1;
          end

          // hold until all finish

          // free trx
          `delay(m_conf.half_cycle);
          m_vif.AXI_WVALID <= 1'b0;
          m_vif.AXI_WLAST  <= 1'b0;
          i = 0;
          m_trx.data_done = `TRUE;
          @(posedge m_vif.AXI_ACLK);

          m_wr_data_indx += 1;

        end else begin
          @(posedge m_vif.AXI_ACLK);
        end
      end

endtask : sent_data_write_trx


// data resp trx collect resp to trx
task AXI_master_driver::received_resp_write_trx();

  forever begin
    `delay(m_conf.half_cycle);
     m_vif.AXI_BREADY <= 1'b0;
     repeat($urandom_range(4,8)) @(posedge m_vif.AXI_ACLK);

    `delay(m_conf.half_cycle);
     m_vif.AXI_BREADY <= 1'b1;
     @(posedge m_vif.AXI_ACLK);

    // hold until BVALID received
    while(!m_vif.AXI_BVALID) @(posedge m_vif.AXI_ACLK);
  end

endtask : received_resp_write_trx


// addr read trx
task AXI_master_driver::sent_addr_read_trx();
    AXI_transfer m_trx;

    forever begin

      repeat(m_rd_queue.size()==0) @(posedge m_vif.AXI_ACLK);

      if (m_rd_addr_indx < m_rd_queue.size()) begin
          m_trx = m_rd_queue[m_rd_addr_indx];

          repeat(m_trx.addr_rd_delay) @(posedge m_vif.AXI_ACLK);

          // sent trx
          `delay(m_conf.half_cycle);
          m_vif.AXI_ARVALID <= 1'b1;
          m_vif.AXI_ARID    <= m_trx.id;
          m_vif.AXI_ARADDR  <= m_trx.addr;
          m_vif.AXI_ARREADY <= m_trx.region;
          m_vif.AXI_ARLEN   <= m_trx.len;
          m_vif.AXI_ARSIZE  <= m_trx.size;
          m_vif.AXI_ARBURST <= m_trx.burst;
          m_vif.AXI_ARLOCK  <= m_trx.lock;
          m_vif.AXI_ARCACHE <= m_trx.cache;
          m_vif.AXI_ARPROT  <= m_trx.prot;
          m_vif.AXI_ARQOS   <= m_trx.qos;
          @(posedge m_vif.AXI_ACLK);

          // hold until ARREADY received
          while(!m_vif.AXI_ARREADY) @(posedge m_vif.AXI_ACLK);
          //void'(m_rd_queue.pop_front());

          // free trx
         `delay(m_conf.half_cycle);
         m_vif.AXI_ARVALID <= 1'b0;
         @(posedge m_vif.AXI_ACLK);

         m_rd_addr_indx += 1;

      end else begin
        @(posedge m_vif.AXI_ACLK);
      end
    end

endtask : sent_addr_read_trx


// data read trx
task AXI_master_driver::received_data_read_trx();

  forever begin
    `delay(m_conf.half_cycle);
     m_vif.AXI_RREADY <= 1'b0;
     repeat($urandom_range(4,8)) @(posedge m_vif.AXI_ACLK);

    `delay(m_conf.half_cycle);
     m_vif.AXI_RREADY <= 1'b1;
    @(posedge m_vif.AXI_ACLK);

     // hold until RVALID received
     while(!m_vif.AXI_RVALID) @(posedge m_vif.AXI_ACLK);

    // continuous burst case
    `delay(m_conf.half_cycle);
    m_vif.AXI_RREADY <= 1'b1;
    repeat($urandom_range(4,16)) @(posedge m_vif.AXI_ACLK);
  end

endtask : received_data_read_trx


// finish read trx

`endif // AXI_MASTER_DRIVER_SV


