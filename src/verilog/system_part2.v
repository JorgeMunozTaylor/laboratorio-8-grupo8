/*
    Modified by Jorge Muñoz Taylor
    Carné A53863
    IE0424
    Laboratory 8
    II-2020

	Part 2
*/

`timescale 1 ns / 1 ps

module system (
	input            clk,
	input            resetn,

	input            PS2_CLK,
	input 			 PS2_DATA,

	output           trap,
	output reg [7:0] out_byte,
	output reg       out_byte_en,

	output     [7:0] catodes,
	output     [7:0] anodes
);
	// set this to 0 for better timing but less performance/MHz
	parameter FAST_MEMORY = 1;

	// 4096 32bit words = 16kB memory
	parameter MEM_SIZE = 4096;

	wire mem_valid;
	wire mem_instr;
	reg mem_ready;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [3:0] mem_wstrb;
	reg [31:0] mem_rdata;

	wire mem_la_read;
	wire mem_la_write;
	wire [31:0] mem_la_addr;
	wire [31:0] mem_la_wdata;
	wire [3:0] mem_la_wstrb;

	picorv32 picorv32_core (
		.clk         (clk         ),
		.resetn      (resetn      ),
		.trap        (trap        ),
		.mem_valid   (mem_valid   ),
		.mem_instr   (mem_instr   ),
		.mem_ready   (mem_ready   ),
		.mem_addr    (mem_addr    ),
		.mem_wdata   (mem_wdata   ),
		.mem_wstrb   (mem_wstrb   ),
		.mem_rdata   (mem_rdata   ),
		.mem_la_read (mem_la_read ),
		.mem_la_write(mem_la_write),
		.mem_la_addr (mem_la_addr ),
		.mem_la_wdata(mem_la_wdata),
		.mem_la_wstrb(mem_la_wstrb)
	);

	reg [31:0] memory [0:MEM_SIZE-1];

`ifdef SYNTHESIS
    initial $readmemh("../firmware/firmware.hex", memory);
`else
	initial $readmemh("firmware.hex", memory);
`endif


	/* Instance of the module prs_game and his conections */
	reg  [3:0] text;
	reg  enable = 1;
	wire click;
	wire selection;
	wire transfer_ready;
	
	prs_game PRS_GAME
	(
		.CLK            ( clk            ),
		.RESET          ( resetn         ),
		.enable         ( enable         ),
		.data_PS2       ( PS2_DATA       ),
		.CLK_PS2        ( PS2_CLK        ),
		.text           ( text           ),
		.transfer_ready ( transfer_ready ),
    	.selection      ( selection      ),
		.click          ( click          ),
		.catodes        ( catodes        ),
		.anodes         ( anodes         )
	);
	/**/

	// Used to generade a "random" number in range 0-2
	reg [1:0] pseudo = 0;

	/* The algorithm its simple, only sum 1 to pseudo every
	posedge clk and pass his value to CPU when need it, we dont
	know in whick clock cycle the CPU will read it, so is 
	almost imposible to know the actuall value */
	always @( posedge clk )
	begin
		if ( pseudo == 2)
			pseudo = 0;
		else
			pseudo = pseudo+1;
	end
	/**/


	reg [31:0] m_read_data;
	reg m_read_en;
	reg temp = 0;


	generate if (FAST_MEMORY) begin
		always @(posedge clk) begin
			mem_ready <= 1;
			out_byte_en <= 0;
			mem_rdata <= memory[mem_la_addr >> 2];
			if (mem_la_write && (mem_la_addr >> 2) < MEM_SIZE) begin
				if (mem_la_wstrb[0]) memory[mem_la_addr >> 2][ 7: 0] <= mem_la_wdata[ 7: 0];
				if (mem_la_wstrb[1]) memory[mem_la_addr >> 2][15: 8] <= mem_la_wdata[15: 8];
				if (mem_la_wstrb[2]) memory[mem_la_addr >> 2][23:16] <= mem_la_wdata[23:16];
				if (mem_la_wstrb[3]) memory[mem_la_addr >> 2][31:24] <= mem_la_wdata[31:24];
			end
			else
			if (mem_la_write && mem_la_addr == 32'h1000_0000) begin
				out_byte_en <= 1;
				out_byte    <= mem_la_wdata;
				text        <= mem_la_wdata;
			end

			else
			if (mem_la_read && mem_la_addr == 32'h1000_0008) begin
				/* If the mouse end the 4 bytes transfer do 
				 the scroll wheel read (in selection variable) */
				if ( transfer_ready == 1 ) begin

					if ( temp == 0) 
					begin
						temp = 1;
						mem_rdata <= selection; 
					end
				end
				else 
				begin
					temp       = 0;
					mem_rdata <= 0;
				end
			end

			// Read the right click of the mouse
			else
			if (mem_la_read && mem_la_addr == 32'h1000_000C) begin
				mem_rdata <= click; 
			end

			// Read the "random" number
			else
			if (mem_la_read && mem_la_addr == 32'h2000_0000) begin
				mem_rdata <= pseudo; 
			end
		end
	end else begin
		always @(posedge clk) begin
			m_read_en <= 0;
			mem_ready <= mem_valid && !mem_ready && m_read_en;

			m_read_data <= memory[mem_addr >> 2];
			mem_rdata <= m_read_data;

			out_byte_en <= 0;

			(* parallel_case *)
			case (1)
				mem_valid && !mem_ready && !mem_wstrb && (mem_addr >> 2) < MEM_SIZE: begin
					m_read_en <= 1;
				end
				mem_valid && !mem_ready && |mem_wstrb && (mem_addr >> 2) < MEM_SIZE: begin
					if (mem_wstrb[0]) memory[mem_addr >> 2][ 7: 0] <= mem_wdata[ 7: 0];
					if (mem_wstrb[1]) memory[mem_addr >> 2][15: 8] <= mem_wdata[15: 8];
					if (mem_wstrb[2]) memory[mem_addr >> 2][23:16] <= mem_wdata[23:16];
					if (mem_wstrb[3]) memory[mem_addr >> 2][31:24] <= mem_wdata[31:24];
					mem_ready <= 1;
				end
				mem_valid && !mem_ready && |mem_wstrb && mem_addr == 32'h1000_0000: begin
					out_byte_en <= 1;
					//out_byte <= mem_wdata;
					mem_ready <= 1;
				end
			endcase
		end
	end endgenerate
endmodule
