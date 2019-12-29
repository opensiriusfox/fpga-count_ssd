`timescale 10ps/1ps
`define SIMULATION_TIME
//`include "top.v"

module top_tb;

	reg tb_clk;
	always #5 tb_clk = (tb_clk === 1'b0);

	reg [3:0] tb_sw;
	wire user_led;
	wire user_usb;
	wire [6:0] anodes;
	wire cathode;

	top Ut (
		.CLK(tb_clk),
		.SW(tb_sw),
		.LED_USER(user_led),
		.ssd_anode(anodes),
		.ssd_cathode(cathode)
	);

	reg [4095:0] vcdfile;
	initial begin
		if ($value$plusargs("vcd=%s", vcdfile)) begin
			$dumpfile(vcdfile);
			$dumpvars(1, Ut);
		end

		tb_sw = 4'b1111;

		repeat (21) @(posedge tb_clk);

		$display("starting.");
		repeat (17) begin
			repeat (10) @(posedge tb_clk);
			tb_sw = tb_sw + 1;
			//$display("%X", tb_sw);
		end

		repeat (20) @(posedge tb_clk);

		$display("done!");
		$finish;
	end

endmodule