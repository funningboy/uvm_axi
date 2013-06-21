
`ifndef AXI_MASTER_WRITE_SEQ_LIB_SV
`define AXI_MASTER_WRITE_SEQ_LIB_SV

//---------------------------------------------
// SEQUENCE: write_seq
// create write trx
//---------------------------------------------
class AXI_master_write_seq extends AXI_transfer;

  AXI_transfer m_trx;

  function new(string name            = "axi_master_write_seq",
               int unsigned addr      = 32'h0000_1000,
               byte_enum ibyte        = BYTE_4,
               len_enum len           = LEN_4,
               burst_enum burst       = INCR,
               int unsigned id        = 1,
               int unsigned data[$]   = { 32'h0000_0001,
                                          32'h0000_0002,
                                          32'h0000_0003,
                                          32'h0000_0004 },
               int unsigned strb[$]   = { 4'b1111,
                                          4'b1111,
                                          4'b1111,
                                          4'b1111 },
               int unsigned addr_delay  = 0,
               int unsigned data_delay  = 0,
               int unsigned resp_delay  = 0
                );

    super.new(name);
    $cast(m_trx, super);

    m_trx.rw            = WRITE;
    m_trx.addr          = addr;
    m_trx.size          = ibyte;
    m_trx.len           = len;
    m_trx.burst         = burst;
    m_trx.id            = id;
//    m_trx.data_bytes    = 4;
    m_trx.data          = data;
    m_trx.strb          = strb;
    m_trx.addr_wt_delay = addr_delay;
    m_trx.data_wt_delay = data_delay;
    m_trx.resp_wt_delay = resp_delay;

  endfunction

  `uvm_object_utils(AXI_master_write_seq)

endclass : AXI_master_write_seq

`endif // AXI_MASTER_WRITE_SEQ_LIB_SV
