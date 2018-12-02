`default nettype_none

module zeroriscy_vector_alu
(
	input logic [3:0][31:0] argA, argB,
	input logic [3:0] opcode,

	output [3:0][31:0] res
);

	always_comb begin
		for (int i = 0; i < 4; i++) begin 
			unique case (opcode)
				VEC_ADD: begin
					res[i] = argA[i] + argB[i];
				end
				VEC_SUB: begin
					res[i] = argA[i] - argB[i];
				end
				VEC_SLL: begin
					res[i] = argA[i] << argB[i][4:0];
				end
				VEC_SRL: begin
					res[i] = argA[i] >> argB[i][4:0];
				end
				VEC_SRA: begin
					res[i] = $signed(argA[i]) >>> argB[i][4:0];
				end
			endcase
	    end
	end

endmodule : zeroriscy_vector_alu