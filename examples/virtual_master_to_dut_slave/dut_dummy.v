
`include "axi_slave.v"

module dut_dummy( input clock, input reset);

axi_slave # ( .AXI_ID_WIDTH(4) ) axi_slave_0
(
	 	.clk           (clock),
		.rstn          (reset),

		// AXI write address channel
		.i_awaddr      (axi_vif_0.AXI_AWADDR),
		.i_awid        (axi_vif_0.AXI_AWID),
		.i_awlen       (axi_vif_0.AXI_AWLEN),
		.i_awvalid     (axi_vif_0.AXI_AWVALID),
		.o_awready     (axi_vif_0.AXI_AWREADY),

		// AXI write data channel
		.i_wdata       (axi_vif_0.AXI_WDATA),
		.i_wid         (axi_vif_0.AXI_WID),
		.i_wstrb       (axi_vif_0.AXI_WSTRB),
		.i_wlast       (axi_vif_0.AXI_WLAST),
		.i_wvalid      (axi_vif_0.AXI_WVALID),
		.o_wready      (axi_vif_0.AXI_WREADY),
		.o_bresp       (axi_vif_0.AXI_BRESP),
		.o_bid         (axi_vif_0.AXI_BID),
		.o_bvalid      (axi_vif_0.AXI_BVALID),
		.i_bready      (axi_vif_0.AXI_BREADY),

		// AXI read address channel
		.i_araddr       (axi_vif_0.AXI_ARADDR),
		.i_arid         (axi_vif_0.AXI_ARID),
		.i_arlen        (axi_vif_0.AXI_ARLEN),
		.i_arvalid      (axi_vif_0.AXI_ARVALID),
		.o_arready      (axi_vif_0.AXI_ARREADY),

		// AXI read data channel
		.o_rdata        (axi_vif_0.AXI_RDATA),
		.o_rid          (axi_vif_0.AXI_RID),
		.o_rresp        (axi_vif_0.AXI_RRESP),
		.o_rlast        (axi_vif_0.AXI_RLAST),
		.o_rvalid       (axi_vif_0.AXI_RVALID),
		.i_rready       (axi_vif_0.AXI_RREADY)
);

endmodule
