/*
    Modified by Jorge Muñoz Taylor
    Carné A53863
    IE0424
    Laboratory 8
    II-2020
*/

`timescale 1 ns / 1 ps

module system_tb;
	reg clk = 1;
	always #5 clk = ~clk;

	reg resetn = 0;
	initial begin
		if ($test$plusargs("vcd")) begin
			$dumpfile("system.vcd");
			$dumpvars(0, system_tb);
		end
		repeat (100) @(posedge clk);
		resetn <= 1;
	end

	wire trap;
	//wire [7:0] out_byte;
	wire out_byte_en;
	wire [7:0] catodes;
	wire [7:0] anodes;

	system uut (
		.clk        (clk        ),
		.resetn     (resetn     ),
		.trap       (trap       ),
		//.out_byte   (out_byte   ),
		.out_byte_en(out_byte_en),
		.catodes    (catodes    ),
		.anodes     (anodes     )
	);

	always @(posedge clk) begin
		if (resetn && out_byte_en) begin
			$write("%c", out_byte);
			$fflush;
		end
		if (resetn && trap) begin
			$finish;
		end
	end
endmodule
