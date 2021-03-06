/*
	there is an issue with the ADC_WINGEN, where TOKEN is implemented to prevent retriggering. But also at the same time, if ADC_CLOCK is generated after ACQ_WND rises, the TOKEN is not resetted to 0, which will prevent the state machine from running. It is fixed by having reset button implemented to reset the TOKEN to 0 just before any acquisition. This is done in C Programming
*/

module NMR_Controller
#(
	parameter PULSE_AND_DELAY_WIDTH = 32,
	parameter ECHO_PER_SCAN_WIDTH = 32,
	parameter ADC_INIT_DELAY_WIDTH = 32,
	parameter SAMPLES_PER_ECHO_WIDTH = 32,
	parameter NMR_MAIN_TIMER_WIDTH = 32,
	parameter ADC_DATA_WIDTH = 16,	// ADC interface to FIFO width
	parameter ADC_PHYS_WIDTH = 14, 	// ADC physical data width
	parameter ADC_LATENCY = 5		// check the datasheet of LTC1746 for this
)
(
	// control signals
	input 	START /* synthesis keep = 1 */,
	output 	FSMSTAT /* synthesis keep = 1 */,
	
	// nmr parameters
	input [PULSE_AND_DELAY_WIDTH-1:0]	T1_PULSE180,
	input [PULSE_AND_DELAY_WIDTH-1:0]	T1_DELAY,
	input [PULSE_AND_DELAY_WIDTH-1:0]	PULSE90,
	input [PULSE_AND_DELAY_WIDTH-1:0]	DELAY_NO_ACQ,
	input [PULSE_AND_DELAY_WIDTH-1:0]	PULSE180,
	input [PULSE_AND_DELAY_WIDTH-1:0]	DELAY_WITH_ACQ,
	input [ECHO_PER_SCAN_WIDTH-1:0]		ECHO_PER_SCAN,	// echo per scan integer number
	input [SAMPLES_PER_ECHO_WIDTH-1:0]	SAMPLES_PER_ECHO,
	input [ADC_INIT_DELAY_WIDTH-1:0]	ADC_INIT_DELAY,
	input [ADC_INIT_DELAY_WIDTH-1:0]	RX_DELAY, 
	
	// nmr rf tx-output (differential)
	output RF_OUT_P,
	output RF_OUT_N,
	
	// nmr control signals
	input PHASE_CYCLE, 	// phase cycle control bit
	output EN_ADC,		// enable adc
	output EN_RX,		// enable receiver signal
	output reg ACQ_WND_DLY,	// delayed acquisition window for broadband board, mainly used for DUP_EN or RX_EN
	output reg EN_QSW,	// enable Q-switch
	
	// ADC bus
	input [ADC_PHYS_WIDTH-1:0] Q_IN,
	input Q_IN_OV,
	
	// data output
	output [ADC_DATA_WIDTH-1:0] ADC_OUT_DATA,
	output ADC_DATA_VALID /* synthesis keep = 1 */,
	
	// system signals
	input PULSEPROG_CLK,
	output ADC_CLK,
	input RESET
);

	wire ACQ_WND /* synthesis keep = 1 */;
	wire ACQ_EN;
	wire START_SYNC /* synthesis keep = 1 */;
	wire ACQ_WND_PULSED;
	
	CDC_Input_Synchronizer
	#(
		.SYNC_REG_LEN (4)
	)
	start_cnt_cdc
	(
		.ASYNC_IN	(START),
		.SYNC_OUT	(START_SYNC),
		.CLK		(PULSEPROG_CLK)
	);
	
	NMR_PULSE_PROGRAM
	#(
		.PULSE_AND_DELAY_WIDTH (PULSE_AND_DELAY_WIDTH),
		.ECHO_PER_SCAN_WIDTH (ECHO_PER_SCAN_WIDTH),
		.NMR_MAIN_TIMER_WIDTH (NMR_MAIN_TIMER_WIDTH)

	)
	NMR_PULSE_PROGRAM1
	(
		// control signals
		.START 			(START_SYNC),
		.FSMSTAT 		(FSMSTAT),
		
		// nmr control signals
		.PHASE_CYC		(PHASE_CYCLE),
		.ACQ_WND 		(ACQ_WND),
		
		// nmr parameters
		.T1_PULSE180	(T1_PULSE180),
		.T1_DELAY		(T1_DELAY),
		.PULSE90 		(PULSE90),
		.DELAY_NO_ACQ 	(DELAY_NO_ACQ),
		.PULSE180 		(PULSE180),
		.DELAY_WITH_ACQ	(DELAY_WITH_ACQ),
		.ECHO_PER_SCAN 	(ECHO_PER_SCAN),
		
		// adc clock generator
		.ADC_CLK		(ADC_CLK),
		
		// nmr tx clock output
		.TX_OUT_P		(RF_OUT_P),
		.TX_OUT_N		(RF_OUT_N),
		
		// system signals
		.CLK			(PULSEPROG_CLK),
		.RESET			(RESET)
	);
	
	ADC_ACQ_WINGEN
	# (
		.SAMPLES_PER_ECHO_WIDTH (SAMPLES_PER_ECHO_WIDTH),
		.ADC_INIT_DELAY_WIDTH (ADC_INIT_DELAY_WIDTH) 
	)
	ADC_ACQ_WINGEN1
	(

		// parameters
		.ADC_INIT_DELAY (ADC_INIT_DELAY),
		.SAMPLES_PER_ECHO (SAMPLES_PER_ECHO),
		
		// control signal
		.ACQ_WND (ACQ_WND),
		.ACQ_EN (ACQ_EN),
		
		// system signal
		.CLK (ADC_CLK),
		.RESET (RESET)
	);
	
	ADC_LTC1746_DRV 
	# (
		.ADC_WIDTH		(ADC_PHYS_WIDTH), 	// ADC width given by the datasheet
		.ADC_LATENCY	(ADC_LATENCY) 		// ADC latency given by the datasheet
	)
	ADC_LTC1746_DRV1
	(
		// digital data
		.Q_IN		(Q_IN),								// digital data in
		.Q_IN_OV	(Q_IN_OV),							// digital data in overflow
		.Q_OUT		(ADC_OUT_DATA[ADC_PHYS_WIDTH-1:0]),	// digital data out
		.Q_OUT_OV	(ADC_OUT_DATA[ADC_PHYS_WIDTH]),		// digital data out overflow
		
		// control signal
		.acq_en		(ACQ_EN),			// acquisition starts (synced signal)
		.data_ready	(ADC_DATA_VALID),	// data ready signal for capture
		.out_en		(),					// output enable for the ADC
		
		// system signal
		.SYS_CLK	(ADC_CLK),		// system control clock
		.CLKOUT		(),				// clockout generated by the ADC chip
		.RESET		(RESET)			// reset
	);
	assign ADC_OUT_DATA[ADC_DATA_WIDTH-1] = 1'b0; // bit-15 were not initialized anywhere in the ADC
	
	assign EN_ADC = ACQ_EN;
	assign EN_RX = ACQ_WND;
	
	
	
	
	
	// this is to compute delay for RX_EN/DUP_EN control signal, which is named as ACQ_WND_DLY
	GNRL_delayed_pulser
	#(
		.DELAY_WIDTH (32)
	)
	DELAYED_EN_RX1
	(
		// signals
		.SIG_IN	(ACQ_WND),
		.SIG_OUT(ACQ_WND_PULSED),
		
		// parameters
		.DELAY	(RX_DELAY),
		
		// system
		.CLK	(ADC_CLK),
		.RESET	(RESET)
		
	);
	
	reg [9:0] State;
	localparam [9:0]
		S0 = 10'b0000000001,
		S1 = 10'b0000000010,
		S2 = 10'b0000000100,
		S3 = 10'b0000001000,
		S4 = 10'b0000010000,
		S5 = 10'b0000100000,
		S6 = 10'b0001000000,
		S7 = 10'b0010000000,
		S8 = 10'b0100000000,
		S9 = 10'b1000000000;
	always @(posedge ADC_CLK, posedge RESET)
	begin
		if (RESET)
		begin
			
			State <= S0;
			ACQ_WND_DLY <= 1'b0;
			
		end
		else
		begin
		
			case (State)
			
				S0 :
				begin
								
					// Wait for the Start signal
					if (ACQ_WND_PULSED)
						State <= S1;
				
				end
				
				S1 : 
				begin
					
					ACQ_WND_DLY <= 1'b1;
					
					if (ACQ_EN) State <= S3;
					else State <= S2;
						
					
				end
				
				S2 : 
				begin
				
					if (ACQ_EN) State <= S3;
					
				end
				
				S3 : 
				begin
				
					if (!ACQ_EN) State <= S4;
					
				end
				
				S4 : 
				begin
				
					ACQ_WND_DLY <= 1'b0;
					State <= S0;
					
				end
			endcase
		end
				
	end
	
	
	// this is to generate Qswitch enable signal
	reg [9:0] StateX;
	localparam [9:0]
		Sx0 = 3'b001,
		Sx1 = 3'b010,
		Sx2 = 3'b100;
	always @(posedge ADC_CLK, posedge RESET)
	begin
		if (RESET)
		begin
			
			StateX <= Sx0;
			EN_QSW <= 1'b0;
			
		end
		else
		begin
		
			case (StateX)
			
				Sx0 : // find logic low of ACQ_WND
				begin
				
					EN_QSW <= 1'b0;
					if ( !ACQ_WND ) StateX = Sx1;
					
				end
				
				Sx1 : // find rising edge of ACQ_WND
				begin
				
					if ( ACQ_WND ) StateX = Sx2;
				
				end
				
				Sx2 : // find rising edge of ACQ_WND_PULSED
				begin
					
					EN_QSW <= 1'b1;
					if ( ACQ_WND_PULSED ) StateX = Sx0;
				
				end
				
			endcase
		end
	end

endmodule
