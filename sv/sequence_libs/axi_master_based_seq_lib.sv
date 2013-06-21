`ifndef AXI_MASTER_BASED_SEQ_LIB_SV
`define AXI_MASTER_BASED_SEQ_LIB_SV

class AXI_master_base_seq extends AXI_base_seq;

  function new(string name="axi_master_base_seq");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(AXI_master_base_seq)
  `uvm_object_utils_end

  `uvm_declare_p_sequencer(AXI_master_sequencer)

// Use a base sequence to raise/drop objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask

endclass : AXI_master_base_seq

`endif // AXI_MASTER_BASED_SEQ_LIB_SV

