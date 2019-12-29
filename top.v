`include "library/ssd_decode_hex.v"
`include "library/clkdiv_ms.v"

// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,		// 16MHz clock

	input [3:0] SW,
    output USBPU,	// USB pull-up resistor
    output LED_USER,	// User/boot LED next to power LED

	output [6:0] ssd_anode,
	output ssd_cathode //
);
    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;
	assign ssd_cathode = 0;

	wire clk_human;
	reg [15:0] count;
	wire [3:0] dig0;
	wire [3:0] dig1;
	wire [3:0] dig2;
	wire [3:0] dig3;

	assign dig0 = count[ 3: 0];
	assign dig1 = count[ 7: 4];
	assign dig2 = count[11: 8];
	assign dig3 = count[15:12];

	initial begin
		count = 0;
	end

	always @(posedge clk_human) begin
		count = count + 1;
	end

	clkdiv_ms Uclk(
		.clk_in(CLK),
		.clk_out(clk_human)
	);

	ssd_decode_hex Ussd(
		.value(count[3:0]),
		.a(ssd_anode[0]),
		.b(ssd_anode[1]),
		.c(ssd_anode[2]),
		.d(ssd_anode[3]),
		.e(ssd_anode[4]),
		.f(ssd_anode[5]),
		.g(ssd_anode[6])
	);

	/*
	////////////////////////////////////////////////////////////////////////////
    // pattern that will be flashed over the LED over time
    wire [30:0] blink_pattern = 30'b0101_0100_0111_0111_0111_0001_0101;
	initial begin
		mag_counter <= 0;
	end
    always @(posedge CLK) begin
        mag_counter <= mag_counter + 1;
    end
    // light up the LED according to the pattern
    assign LED_USER = blink_pattern[mag_counter[25:21]];
	////////////////////////////////////////////////////////////////////////////
	*/
endmodule
