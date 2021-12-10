module razor_reg_32 (d32, q32, reset32, clk, error32);
	input [31:0] d32;
	input clk, reset32;
	output [31:0] q32, error32;

	genvar i;
	generate
		for (i = 0; i < 32; i = i+1) begin
			razorflipflop reg_dff (.clk(clk), .d(d32[i]), .reset(reset32), .q(q32[i]), .error(error32[i]));
		end
	endgenerate
endmodule