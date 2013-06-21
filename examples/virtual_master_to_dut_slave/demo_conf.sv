
`ifndef DEMO_CONF_SV
`define DEMO_CONF_SV

class Demo_conf extends AXI_env_conf;

  `uvm_object_utils(Demo_conf)

  function new(string name = "demo_config");
    super.new(name);
    add_slave(.name             ("m_slaves[0]"),
              .start_addr       (32'h0000_0000),
              .end_addr         (32'hFFFF_FFFF),
              .is_active        (UVM_PASSIVE));

    add_master(.name            ("m_masters[0]"),
              .is_active        (UVM_ACTIVE));
  endfunction

endclass : Demo_conf

`endif // DEMO_CONF_SV

