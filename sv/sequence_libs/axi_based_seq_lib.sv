`ifndef AXI_BASED_SEQ_LIB_SV
`define AXI_BASED_SEQ_LIB_SV

//------------------------------------------------------------------------------
// SEQUENCE: base_seq
//------------------------------------------------------------------------------
class AXI_base_seq extends uvm_sequence #(AXI_transfer);

  function new(string name="axi_base_seq");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(AXI_base_seq)
  `uvm_object_utils_end

endclass : AXI_base_seq

`endif // AXI_BASED_SEQ_LIB_SV

