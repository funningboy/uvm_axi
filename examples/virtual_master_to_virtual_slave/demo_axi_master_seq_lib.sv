// testsuite sets....

`ifndef DEMO_AXI_MASTER_SEQ_LIB_SV
`define DEMO_AXI_MASTER_SEQ_LIB_SV


//---------------------------------------------
// SEQUENCE: DEMO_AXI_master_write_data_after_write_addr
//---------------------------------------------
class DEMO_AXI_master_write_data_after_write_addr extends AXI_master_base_seq;

  AXI_master_write_seq  m_wr_seq;
  AXI_master_read_seq   m_rd_seq;

  int unsigned  m_inc_addr  = 0;
  int unsigned  m_inc_data  = 0;
  int unsigned  m_inc_id    = 0;

  `uvm_object_utils(DEMO_AXI_master_write_data_after_write_addr)

  function new(string name="axi_master_write_data_after_write_addr");
    super.new(name);
  endfunction


  virtual task sent_write_trx();

    m_inc_addr = 0;
    m_inc_data = 0;
    m_inc_id   = 0;

    repeat(5) begin

        m_wr_seq = new (
               .name         ("axi_master_write_data_after_write_addr"),
               .addr         (32'h0000_1000 + m_inc_addr),
               .ibyte        (BYTE_4),
               .len          (LEN_4),
               .burst        (INCR),
               .id           (1 + m_inc_id),
               .data         ({ 32'h0000_0001 + m_inc_data,
                                32'h0000_0002 + m_inc_data,
                                32'h0000_0003 + m_inc_data,
                                32'h0000_0004 + m_inc_data} ),
               .strb         ({4'b1111,
                               4'b1111,
                               4'b1111,
                               4'b1111 } ),
               .addr_delay  (0),
               .data_delay  (5), // write data after write addr
               .resp_delay  (0)
         );

        start_item(m_wr_seq);
        finish_item(m_wr_seq);

        m_inc_addr += 32'h0001_0000;
        m_inc_data += 32'h0001_0000;
        m_inc_id   += 1;
    end

  endtask : sent_write_trx


  virtual task sent_read_trx();

    m_inc_addr = 0;
    m_inc_data = 0;
    m_inc_id   = 0;

    repeat(5) begin

        m_rd_seq = new(
               .name         ("axi_master_write_data_after_write_addr"),
               .addr         (32'h0000_1000 + m_inc_addr),
               .ibyte        (BYTE_4),
               .len          (LEN_4),
               .burst        (INCR),
               .id           (1 + m_inc_id),
               .addr_delay   (20),
               .data_delay   (0)
         );

        start_item(m_rd_seq);
        finish_item(m_rd_seq);

        m_inc_addr += 32'h0001_0000;
        m_inc_data += 32'h0001_0000;
        m_inc_id   += 1;
    end

  endtask: sent_read_trx


  virtual task body();

    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)

    sent_write_trx();
    sent_read_trx();

  endtask

endclass : DEMO_AXI_master_write_data_after_write_addr


//--------------------------------------------
// SEQUENCE: DEMO_AXI_master_write_addr_after_write_data
//--------------------------------------------
class DEMO_AXI_master_write_addr_after_write_data extends AXI_master_base_seq;

  AXI_master_write_seq  m_wr_seq;
  AXI_master_read_seq   m_rd_seq;

  int unsigned  m_inc_addr  = 0;
  int unsigned  m_inc_data  = 0;
  int unsigned  m_inc_id    = 0;

  `uvm_object_utils(DEMO_AXI_master_write_addr_after_write_data)

  function new(string name="axi_master_write_addr_after_write_data");
    super.new(name);
  endfunction


  virtual task sent_write_trx();

    m_inc_addr = 0;
    m_inc_data = 0;
    m_inc_id   = 0;

    repeat(20) begin

        m_wr_seq = new (
               .name         ("axi_master_write_data_after_write_addr"),
               .addr         (32'h0000_1000 + m_inc_addr),
               .ibyte        (BYTE_4),
               .len          (LEN_4),
               .burst        (INCR),
               .id           (1 + m_inc_id),
               .data         ({ 32'h0000_0001 + m_inc_data,
                                32'h0000_0002 + m_inc_data,
                                32'h0000_0003 + m_inc_data,
                                32'h0000_0004 + m_inc_data} ),
               .strb         ({4'b1111,
                               4'b1111,
                               4'b1111,
                               4'b1111 } ),
               .addr_delay  (5),// write addr after write data
               .data_delay  (0),
               .resp_delay  (0)
         );

        start_item(m_wr_seq);
        finish_item(m_wr_seq);

        m_inc_addr += 32'h0001_0000;
        m_inc_data += 32'h0001_0000;
        m_inc_id   += 1;
    end

  endtask : sent_write_trx


  virtual task sent_read_trx();

    m_inc_addr = 0;
    m_inc_data = 0;
    m_inc_id   = 0;

    repeat(20) begin

        m_rd_seq = new(
               .name         ("axi_master_write_data_after_write_addr"),
               .addr         (32'h0000_1000 + m_inc_addr),
               .ibyte        (BYTE_4),
               .len          (LEN_4),
               .burst        (INCR),
               .id           (1 + m_inc_id),
               .addr_delay   (20),
               .data_delay   (0)
         );

        start_item(m_rd_seq);
        finish_item(m_rd_seq);

        m_inc_addr += 32'h0001_0000;
        m_inc_data += 32'h0001_0000;
        m_inc_id   += 1;
    end

  endtask: sent_read_trx


  virtual task body();

    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)

    sent_write_trx();
    sent_read_trx();

  endtask

endclass : DEMO_AXI_master_write_addr_after_write_data


//--------------------------------------------
// SEQUENCE: DEMO_AXI_master_write_out_of_performance
//--------------------------------------------
class DEMO_AXI_master_write_out_of_performance extends AXI_master_base_seq;

  AXI_master_write_seq  m_wr_seq;

  int unsigned  m_inc_addr  = 0;
  int unsigned  m_inc_data  = 0;
  int unsigned  m_inc_id    = 0;

  `uvm_object_utils(DEMO_AXI_master_write_out_of_performance)

  function new(string name="axi_master_write_out_of_performance");
    super.new(name);
  endfunction


  virtual task sent_write_trx();

    m_inc_addr = 0;
    m_inc_data = 0;
    m_inc_id   = 0;

    repeat(20) begin

        m_wr_seq = new (
               .name         ("axi_master_write_data_after_write_addr"),
               .addr         (32'h0000_1000 + m_inc_addr),
               .ibyte        (BYTE_4),
               .len          (LEN_4),
               .burst        (INCR),
               .id           (1 + m_inc_id),
               .data         ({ 32'h0000_0001 + m_inc_data,
                                32'h0000_0002 + m_inc_data,
                                32'h0000_0003 + m_inc_data,
                                32'h0000_0004 + m_inc_data} ),
               .strb         ({4'b1111,
                               4'b1111,
                               4'b1111,
                               4'b1111 } ),
               .addr_delay  (200),// write addr after write data
               .data_delay  (0),
               .resp_delay  (0)
         );

        start_item(m_wr_seq);
        finish_item(m_wr_seq);

        m_inc_addr += 32'h0001_0000;
        m_inc_data += 32'h0001_0000;
        m_inc_id   += 1;
    end

  endtask : sent_write_trx

  virtual task body();

    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)

    sent_write_trx();
  endtask

endclass : DEMO_AXI_master_write_out_of_performance


//--------------------------------------------
// SEQUENCE: DEMO_AXI_master_read_out_of_performance
//--------------------------------------------
class DEMO_AXI_master_read_out_of_performance extends AXI_master_base_seq;

  AXI_master_read_seq  m_rd_seq;

  int unsigned  m_inc_addr  = 0;
  int unsigned  m_inc_data  = 0;
  int unsigned  m_inc_id    = 0;

  `uvm_object_utils(DEMO_AXI_master_read_out_of_performance)

  function new(string name="axi_master_read_out_of_performance");
    super.new(name);
  endfunction

  virtual task sent_read_trx();

    m_inc_addr = 0;
    m_inc_data = 0;
    m_inc_id   = 0;

    repeat(20) begin

        m_rd_seq = new(
               .name         ("axi_master_write_data_after_write_addr"),
               .addr         (32'h0000_1000 + m_inc_addr),
               .ibyte        (BYTE_4),
               .len          (LEN_4),
               .burst        (INCR),
               .id           (1 + m_inc_id),
               .addr_delay   (100),
               .data_delay   (0)
         );

        start_item(m_rd_seq);
        finish_item(m_rd_seq);

        m_inc_addr += 32'h0001_0000;
        m_inc_data += 32'h0001_0000;
        m_inc_id   += 1;
    end

  endtask: sent_read_trx


  virtual task body();

    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)

    sent_read_trx();
  endtask

endclass : DEMO_AXI_master_read_out_of_performance



`endif // DEMO_AXI_MASTER_SEQ_LIB_SV
