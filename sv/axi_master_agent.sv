/*--------------------------------------
// AXI master agent
// file : axi_master_agent.sv
// author : SeanChen
// description : master agent, contain monitor or sequencer if the ACTIVE is on
// date : 2013/05/06
---------------------------------------*/

`ifndef AXI_MASTER_AGENT_SV
`define AXI_MASTER_AGENT_SV

class AXI_master_agent extends uvm_agent;

  AXI_master_conf     m_conf;
  virtual interface AXI_vif m_vif;

	AXI_master_driver		  m_driver;
	AXI_master_sequencer	m_sequencer;
	AXI_master_monitor		m_monitor;

	// reserve fields
	`uvm_component_utils_begin(AXI_master_agent)
	`uvm_component_utils_end


	// constructor
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new


	// build phase
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		m_monitor = AXI_master_monitor::type_id::create("m_monitor", this);

		if (m_conf.is_active == UVM_ACTIVE) begin
			m_driver = AXI_master_driver::type_id::create("m_driver", this);
			m_sequencer = AXI_master_sequencer::type_id::create("m_sequencer", this);
		end

		m_monitor.assign_conf(m_conf);

		if (m_conf.is_active == UVM_ACTIVE) begin
//			m_sequencer.assign_conf(axi_conf);
			m_driver.assign_conf(m_conf);
		end

		m_monitor.assign_vi(m_vif);
		if (m_conf.is_active == UVM_ACTIVE) begin
//			m_sequencer.assign_vi(m_vif);
			m_driver.assign_vi(m_vif);
		end

	endfunction : build_phase


	// connect phase
	virtual function void connect_phase(uvm_phase phase);
    if (m_conf.is_active == UVM_ACTIVE) begin
		  m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    end
	endfunction : connect_phase


	// assign virtual interface
	virtual function void assign_vi(virtual interface AXI_vif axi_vif);
    m_vif = axi_vif;
	endfunction : assign_vi


	// assign configure
	virtual function void assign_conf(AXI_master_conf axi_conf);
    m_conf = axi_conf;
	endfunction : assign_conf

endclass : AXI_master_agent


`endif // AXI_master_agent

