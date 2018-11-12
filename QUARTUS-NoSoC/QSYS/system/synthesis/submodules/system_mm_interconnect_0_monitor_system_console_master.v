// system_mm_interconnect_0_monitor_system_console_master.v

// This file was auto-generated from altera_avalon_monitor_and_gatherer_hw.tcl.  If you edit it your changes
// will probably be lost.
// 
// Generated using ACDS version 17.1 590

`timescale 1 ps / 1 ps
module system_mm_interconnect_0_monitor_system_console_master #(
		parameter ST_DATA_W       = 108,
		parameter PKT_BYTE_CNT_H  = 76,
		parameter PKT_BYTE_CNT_L  = 74,
		parameter PKT_TRANS_WRITE = 70,
		parameter PKT_TRANS_READ  = 71
	) (
		input  wire         clk_clk,       //   clk.clk
		input  wire         reset_reset_n, // reset.reset_n
		input  wire         cp_valid,      //    cp.valid
		input  wire [107:0] cp_data,       //      .data
		input  wire         cp_ready,      //      .ready
		input  wire         rp_valid       //    rp.valid
	);

	wire         trace_endpoint_debug_reset_reset;                 // trace_endpoint:reset -> [gatherer:reset, mm_interconnect_0:gatherer_reset_reset_bridge_in_reset_reset, mm_interconnect_1:gatherer_reset_reset_bridge_in_reset_reset, mm_interconnect_2:gatherer_reset_reset_bridge_in_reset_reset, pm:avs_reset_reset]
	wire         gatherer_capture_valid;                           // gatherer:capture_valid -> trace_endpoint:capture_valid
	wire  [31:0] gatherer_capture_data;                            // gatherer:capture_data -> trace_endpoint:capture_data
	wire         gatherer_capture_ready;                           // trace_endpoint:capture_ready -> gatherer:capture_ready
	wire         gatherer_capture_startofpacket;                   // gatherer:capture_startofpacket -> trace_endpoint:capture_startofpacket
	wire         gatherer_capture_endofpacket;                     // gatherer:capture_endofpacket -> trace_endpoint:capture_endofpacket
	wire   [1:0] gatherer_capture_empty;                           // gatherer:capture_empty -> trace_endpoint:capture_empty
	wire  [31:0] gatherer_data_readdata;                           // mm_interconnect_0:gatherer_data_readdata -> gatherer:data_readdata
	wire         gatherer_data_waitrequest;                        // mm_interconnect_0:gatherer_data_waitrequest -> gatherer:data_waitrequest
	wire   [3:0] gatherer_data_byteenable;                         // gatherer:data_byteenable -> mm_interconnect_0:gatherer_data_byteenable
	wire         gatherer_data_read;                               // gatherer:data_read -> mm_interconnect_0:gatherer_data_read
	wire   [3:0] gatherer_data_address;                            // gatherer:data_address -> mm_interconnect_0:gatherer_data_address
	wire         gatherer_data_readdatavalid;                      // mm_interconnect_0:gatherer_data_readdatavalid -> gatherer:data_readdatavalid
	wire  [31:0] mm_interconnect_0_pm_data_readdata;               // pm:data_readdata -> mm_interconnect_0:pm_data_readdata
	wire         mm_interconnect_0_pm_data_waitrequest;            // pm:data_waitrequest -> mm_interconnect_0:pm_data_waitrequest
	wire   [1:0] mm_interconnect_0_pm_data_address;                // mm_interconnect_0:pm_data_address -> pm:data_address
	wire         mm_interconnect_0_pm_data_read;                   // mm_interconnect_0:pm_data_read -> pm:data_read
	wire  [31:0] gatherer_config_readdata;                         // mm_interconnect_1:gatherer_config_readdata -> gatherer:config_readdata
	wire         gatherer_config_waitrequest;                      // mm_interconnect_1:gatherer_config_waitrequest -> gatherer:config_waitrequest
	wire   [3:0] gatherer_config_byteenable;                       // gatherer:config_byteenable -> mm_interconnect_1:gatherer_config_byteenable
	wire         gatherer_config_read;                             // gatherer:config_read -> mm_interconnect_1:gatherer_config_read
	wire   [3:0] gatherer_config_address;                          // gatherer:config_address -> mm_interconnect_1:gatherer_config_address
	wire         gatherer_config_readdatavalid;                    // mm_interconnect_1:gatherer_config_readdatavalid -> gatherer:config_readdatavalid
	wire  [31:0] gatherer_config_writedata;                        // gatherer:config_writedata -> mm_interconnect_1:gatherer_config_writedata
	wire         gatherer_config_write;                            // gatherer:config_write -> mm_interconnect_1:gatherer_config_write
	wire  [31:0] mm_interconnect_1_pm_config_readdata;             // pm:config_readdata -> mm_interconnect_1:pm_config_readdata
	wire   [1:0] mm_interconnect_1_pm_config_address;              // mm_interconnect_1:pm_config_address -> pm:config_address
	wire  [31:0] trace_endpoint_control_readdata;                  // mm_interconnect_2:trace_endpoint_control_readdata -> trace_endpoint:control_readdata
	wire         trace_endpoint_control_waitrequest;               // mm_interconnect_2:trace_endpoint_control_waitrequest -> trace_endpoint:control_waitrequest
	wire         trace_endpoint_control_read;                      // trace_endpoint:control_read -> mm_interconnect_2:trace_endpoint_control_read
	wire   [5:0] trace_endpoint_control_address;                   // trace_endpoint:control_address -> mm_interconnect_2:trace_endpoint_control_address
	wire         trace_endpoint_control_write;                     // trace_endpoint:control_write -> mm_interconnect_2:trace_endpoint_control_write
	wire  [31:0] trace_endpoint_control_writedata;                 // trace_endpoint:control_writedata -> mm_interconnect_2:trace_endpoint_control_writedata
	wire  [31:0] mm_interconnect_2_gatherer_control_readdata;      // gatherer:control_readdata -> mm_interconnect_2:gatherer_control_readdata
	wire         mm_interconnect_2_gatherer_control_waitrequest;   // gatherer:control_waitrequest -> mm_interconnect_2:gatherer_control_waitrequest
	wire   [5:0] mm_interconnect_2_gatherer_control_address;       // mm_interconnect_2:gatherer_control_address -> gatherer:control_address
	wire         mm_interconnect_2_gatherer_control_read;          // mm_interconnect_2:gatherer_control_read -> gatherer:control_read
	wire         mm_interconnect_2_gatherer_control_readdatavalid; // gatherer:control_readdatavalid -> mm_interconnect_2:gatherer_control_readdatavalid
	wire         mm_interconnect_2_gatherer_control_write;         // mm_interconnect_2:gatherer_control_write -> gatherer:control_write
	wire  [31:0] mm_interconnect_2_gatherer_control_writedata;     // mm_interconnect_2:gatherer_control_writedata -> gatherer:control_writedata

	generate
		// If any of the display statements (or deliberately broken
		// instantiations) within this generate block triggers then this module
		// has been instantiated this module with a set of parameters different
		// from those it was generated for.  This will usually result in a
		// non-functioning system.
		if (ST_DATA_W != 108)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					st_data_w_check ( .error(1'b1) );
		end
		if (PKT_BYTE_CNT_H != 76)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					pkt_byte_cnt_h_check ( .error(1'b1) );
		end
		if (PKT_BYTE_CNT_L != 74)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					pkt_byte_cnt_l_check ( .error(1'b1) );
		end
		if (PKT_TRANS_WRITE != 70)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					pkt_trans_write_check ( .error(1'b1) );
		end
		if (PKT_TRANS_READ != 71)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					pkt_trans_read_check ( .error(1'b1) );
		end
	endgenerate

	system_mm_interconnect_0_monitor_system_console_master_gatherer gatherer (
		.capture_endofpacket   (gatherer_capture_endofpacket),                     // capture.endofpacket
		.capture_data          (gatherer_capture_data),                            //        .data
		.capture_valid         (gatherer_capture_valid),                           //        .valid
		.capture_ready         (gatherer_capture_ready),                           //        .ready
		.capture_startofpacket (gatherer_capture_startofpacket),                   //        .startofpacket
		.capture_empty         (gatherer_capture_empty),                           //        .empty
		.control_address       (mm_interconnect_2_gatherer_control_address),       // control.address
		.control_read          (mm_interconnect_2_gatherer_control_read),          //        .read
		.control_write         (mm_interconnect_2_gatherer_control_write),         //        .write
		.control_writedata     (mm_interconnect_2_gatherer_control_writedata),     //        .writedata
		.control_readdata      (mm_interconnect_2_gatherer_control_readdata),      //        .readdata
		.control_readdatavalid (mm_interconnect_2_gatherer_control_readdatavalid), //        .readdatavalid
		.control_waitrequest   (mm_interconnect_2_gatherer_control_waitrequest),   //        .waitrequest
		.clk                   (clk_clk),                                          //   clock.clk
		.reset                 (trace_endpoint_debug_reset_reset),                 //   reset.reset
		.data_readdata         (gatherer_data_readdata),                           //    data.readdata
		.data_byteenable       (gatherer_data_byteenable),                         //        .byteenable
		.data_read             (gatherer_data_read),                               //        .read
		.data_address          (gatherer_data_address),                            //        .address
		.data_readdatavalid    (gatherer_data_readdatavalid),                      //        .readdatavalid
		.data_waitrequest      (gatherer_data_waitrequest),                        //        .waitrequest
		.config_readdata       (gatherer_config_readdata),                         //  config.readdata
		.config_writedata      (gatherer_config_writedata),                        //        .writedata
		.config_byteenable     (gatherer_config_byteenable),                       //        .byteenable
		.config_read           (gatherer_config_read),                             //        .read
		.config_write          (gatherer_config_write),                            //        .write
		.config_address        (gatherer_config_address),                          //        .address
		.config_readdatavalid  (gatherer_config_readdatavalid),                    //        .readdatavalid
		.config_waitrequest    (gatherer_config_waitrequest)                       //        .waitrequest
	);

	system_mm_interconnect_0_monitor_system_console_master_pm #(
		.BC_W            (1),
		.ST_DATA_W       (108),
		.PKT_BYTE_CNT_H  (76),
		.PKT_BYTE_CNT_L  (74),
		.PKT_TRANS_WRITE (70),
		.PKT_TRANS_READ  (71)
	) pm (
		.avs_clock_clk    (clk_clk),                               // avs_clock.clk
		.avs_reset_reset  (trace_endpoint_debug_reset_reset),      // avs_reset.reset
		.if_clock_clk     (clk_clk),                               //  if_clock.clk
		.if_reset_reset   (~reset_reset_n),                        //  if_reset.reset
		.cp_valid         (cp_valid),                              //        cp.valid
		.cp_data          (cp_data),                               //          .data
		.cp_ready         (cp_ready),                              //          .ready
		.rp_valid         (rp_valid),                              //        rp.valid
		.data_address     (mm_interconnect_0_pm_data_address),     //      data.address
		.data_read        (mm_interconnect_0_pm_data_read),        //          .read
		.data_readdata    (mm_interconnect_0_pm_data_readdata),    //          .readdata
		.data_waitrequest (mm_interconnect_0_pm_data_waitrequest), //          .waitrequest
		.config_address   (mm_interconnect_1_pm_config_address),   //    config.address
		.config_readdata  (mm_interconnect_1_pm_config_readdata)   //          .readdata
	);

	altera_trace_monitor_endpoint_wrapper #(
		.TRACE_WIDTH       (32),
		.ADDR_WIDTH        (6),
		.READ_LATENCY      (0),
		.HAS_READDATAVALID (0),
		.PREFER_TRACEID    (""),
		.CLOCK_RATE_CLK    (50000000)
	) trace_endpoint (
		.clk                   (clk_clk),                            //         clk.clk
		.reset                 (trace_endpoint_debug_reset_reset),   // debug_reset.reset
		.capture_ready         (gatherer_capture_ready),             //     capture.ready
		.capture_valid         (gatherer_capture_valid),             //            .valid
		.capture_data          (gatherer_capture_data),              //            .data
		.capture_startofpacket (gatherer_capture_startofpacket),     //            .startofpacket
		.capture_endofpacket   (gatherer_capture_endofpacket),       //            .endofpacket
		.capture_empty         (gatherer_capture_empty),             //            .empty
		.control_write         (trace_endpoint_control_write),       //     control.write
		.control_read          (trace_endpoint_control_read),        //            .read
		.control_address       (trace_endpoint_control_address),     //            .address
		.control_writedata     (trace_endpoint_control_writedata),   //            .writedata
		.control_readdata      (trace_endpoint_control_readdata),    //            .readdata
		.control_waitrequest   (trace_endpoint_control_waitrequest), //            .waitrequest
		.control_readdatavalid (1'b0)                                // (terminated)
	);

	system_mm_interconnect_0_monitor_system_console_master_mm_interconnect_0 mm_interconnect_0 (
		.clk_clk_clk                                (clk_clk),                               //                              clk_clk.clk
		.gatherer_reset_reset_bridge_in_reset_reset (trace_endpoint_debug_reset_reset),      // gatherer_reset_reset_bridge_in_reset.reset
		.gatherer_data_address                      (gatherer_data_address),                 //                        gatherer_data.address
		.gatherer_data_waitrequest                  (gatherer_data_waitrequest),             //                                     .waitrequest
		.gatherer_data_byteenable                   (gatherer_data_byteenable),              //                                     .byteenable
		.gatherer_data_read                         (gatherer_data_read),                    //                                     .read
		.gatherer_data_readdata                     (gatherer_data_readdata),                //                                     .readdata
		.gatherer_data_readdatavalid                (gatherer_data_readdatavalid),           //                                     .readdatavalid
		.pm_data_address                            (mm_interconnect_0_pm_data_address),     //                              pm_data.address
		.pm_data_read                               (mm_interconnect_0_pm_data_read),        //                                     .read
		.pm_data_readdata                           (mm_interconnect_0_pm_data_readdata),    //                                     .readdata
		.pm_data_waitrequest                        (mm_interconnect_0_pm_data_waitrequest)  //                                     .waitrequest
	);

	system_mm_interconnect_0_monitor_system_console_master_mm_interconnect_1 mm_interconnect_1 (
		.clk_clk_clk                                (clk_clk),                              //                              clk_clk.clk
		.gatherer_reset_reset_bridge_in_reset_reset (trace_endpoint_debug_reset_reset),     // gatherer_reset_reset_bridge_in_reset.reset
		.gatherer_config_address                    (gatherer_config_address),              //                      gatherer_config.address
		.gatherer_config_waitrequest                (gatherer_config_waitrequest),          //                                     .waitrequest
		.gatherer_config_byteenable                 (gatherer_config_byteenable),           //                                     .byteenable
		.gatherer_config_read                       (gatherer_config_read),                 //                                     .read
		.gatherer_config_readdata                   (gatherer_config_readdata),             //                                     .readdata
		.gatherer_config_readdatavalid              (gatherer_config_readdatavalid),        //                                     .readdatavalid
		.gatherer_config_write                      (gatherer_config_write),                //                                     .write
		.gatherer_config_writedata                  (gatherer_config_writedata),            //                                     .writedata
		.pm_config_address                          (mm_interconnect_1_pm_config_address),  //                            pm_config.address
		.pm_config_readdata                         (mm_interconnect_1_pm_config_readdata)  //                                     .readdata
	);

	system_mm_interconnect_0_monitor_system_console_master_mm_interconnect_2 mm_interconnect_2 (
		.clk_clk_clk                                (clk_clk),                                          //                              clk_clk.clk
		.gatherer_reset_reset_bridge_in_reset_reset (trace_endpoint_debug_reset_reset),                 // gatherer_reset_reset_bridge_in_reset.reset
		.trace_endpoint_control_address             (trace_endpoint_control_address),                   //               trace_endpoint_control.address
		.trace_endpoint_control_waitrequest         (trace_endpoint_control_waitrequest),               //                                     .waitrequest
		.trace_endpoint_control_read                (trace_endpoint_control_read),                      //                                     .read
		.trace_endpoint_control_readdata            (trace_endpoint_control_readdata),                  //                                     .readdata
		.trace_endpoint_control_write               (trace_endpoint_control_write),                     //                                     .write
		.trace_endpoint_control_writedata           (trace_endpoint_control_writedata),                 //                                     .writedata
		.gatherer_control_address                   (mm_interconnect_2_gatherer_control_address),       //                     gatherer_control.address
		.gatherer_control_write                     (mm_interconnect_2_gatherer_control_write),         //                                     .write
		.gatherer_control_read                      (mm_interconnect_2_gatherer_control_read),          //                                     .read
		.gatherer_control_readdata                  (mm_interconnect_2_gatherer_control_readdata),      //                                     .readdata
		.gatherer_control_writedata                 (mm_interconnect_2_gatherer_control_writedata),     //                                     .writedata
		.gatherer_control_readdatavalid             (mm_interconnect_2_gatherer_control_readdatavalid), //                                     .readdatavalid
		.gatherer_control_waitrequest               (mm_interconnect_2_gatherer_control_waitrequest)    //                                     .waitrequest
	);

endmodule