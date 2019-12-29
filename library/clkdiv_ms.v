module clkdiv_ms (
	input clk_in,
	output clk_out //
);

	reg [23:0] counter;
`ifdef SIMULATION_TIME
	assign clk_out = counter[2];
`else
	assign clk_out = counter[22];
`endif

	initial begin
		counter = 0;
	end

	always @(posedge clk_in) begin
		counter = counter + 1;
	end

endmodule