
`ifndef AXI_MASTER_READ_SEQ_LIB_SV
`define AXI_MASTER_READ_SEQ_LIB_SV

//---------------------------------------------
// SEQUENCE: read_seq
// create read trx
//---------------------------------------------
class AXI_master_read_seq extends AXI_transfer;

  AXI_transfer m_trx;

  function new(string name              ="axi_master_read_seq",
               int unsigned addr        = 32'h0000_10000,
               byte_enum ibyte          = BYTE_4,
               len_enum len             = LEN_4,
               burst_enum burst         = INCR,
               int unsigned id          = 1,
               int unsigned addr_delay  = 0,
               int unsigned data_delay  = 0
                );

    super.new(name);
    $cast(m_trx, super);

    m_trx.rw            = READ;
    m_trx.addr          = addr;
    m_trx.size          = ibyte;
    m_trx.len           = len;
    m_trx.burst         = burst;
    m_trx.id            = id;
    m_trx.addr_rd_delay = addr_delay;
    m_trx.data_rd_delay = data_delay;

  endfunction

  `uvm_object_utils(AXI_master_read_seq)

 endclass : AXI_master_read_seq

`endif // AXI_MASTER_READ_SEQ_LIB_SV
