`include "zeroriscy_config.sv"

module zeroriscy_vector_register_file
(
	// Clock and reset
	input logic clk,
	input logic rst_n,

	// Read port R1
	input logic [3:0] raddr_a_i,
	output logic [3:0][31:0] rdata_a_o,

	// Read port R2
	input logic [3:0] raddr_b_i,
	output logic [3:0][31:0] rdata_b_o,

	// Write port W1
	input logic [3:0] waddr_a_i,
	input logic [31:0] wdata_a_i,
	input logic we_a_i

);
	logic [31:0] vec_reg[16][4];

	always_ff @(posedge clk, negedge rst_n) begin
		if (~rst_n) begin
			vec_reg <= 0;
		end
		else begin
			if (we_a_i) begin
				vec_reg[waddr_a_i][0] <= wdata_a_i;
				vec_reg[waddr_a_i][1] <= wdata_a_i;
				vec_reg[waddr_a_i][2] <= wdata_a_i;
				vec_reg[waddr_a_i][3] <= wdata_a_i;
		    end
		end
	end

	genvar i;
	generate
		for (i = 0; i < 4; i++) begin
			assign rdata_a_o[i] = vec_reg[raddr_a_i][i];
			assign rdata_b_o[i] = vec_reg[raddr_b_i][i];
		end
	endgenerate

endmodule : zeroriscy_vector_register_file