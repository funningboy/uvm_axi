
/*--------------------------------------
// AXI slave agent
// file : axi4_slave_agent.sv
// author : SeanChen
// date : 2013/05/06
// description : slave agent, contain monitor or sequencer if the ACTIVE is on
// date : 2013/05/06
---------------------------------------*/

`ifndef AXI_SLAVE_AGENT_SV
`define AXI_SLAVE_AGENT_SV

class AXI_slave_agent extends uvm_agent;

  AXI_slave_conf      m_conf;
  virtual interface AXI_vif m_vif;

	AXI_slave_driver		m_driver;
	AXI_slave_sequencer	m_sequencer;
	AXI_slave_monitor		m_monitor;

	// reserve fields
	`uvm_component_utils_begin(AXI_slave_agent)
	`uvm_component_utils_end


	// constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new


	// build phase
	virtual function void build_phase(uvm_phase phase);
		super.build();

		m_monitor = AXI_slave_monitor::type_id::create("m_monitor", this);
		if (m_conf.is_active == UVM_ACTIVE) begin
			m_driver = AXI_slave_driver::type_id::create("m_driver", this);
			m_sequencer = AXI_slave_sequencer::type_id::create("m_sequencer", this);
		end

		m_monitor.assign_conf(m_conf);
		if (m_conf.is_active == UVM_ACTIVE) begin
//			m_sequencer.assign_conf(m_conf);
			m_driver.assign_conf(m_conf);
		end

  	m_monitor.assign_vi(m_vif);
		if (m_conf.is_active == UVM_ACTIVE) begin
//			m_sequencer.assign_vi(axi_vif);
			m_driver.assign_vi(m_vif);
		end

	endfunction : build_phase


	// connect phase
	virtual function void connect_phase(uvm_phase phase);
    if (m_conf.is_active == UVM_ACTIVE) begin
		  m_driver.seq_item_port.connect(m_sequencer.seq_item_export);

      m_monitor.item_write_port.connect(m_driver.item_write_imp);
      m_monitor.item_read_port.connect(m_driver.item_read_imp);
		end
	endfunction : connect_phase


	// assign virtual interface
	virtual function void assign_vi(virtual interface AXI_vif axi_vif);
    m_vif = axi_vif;
	endfunction : assign_vi


	// assign configure
	virtual function void assign_conf(AXI_slave_conf axi_conf);
    m_conf = axi_conf;
	endfunction : assign_conf

endclass : AXI_slave_agent

`endif // AXI_SLAVE_AGENT_SV

