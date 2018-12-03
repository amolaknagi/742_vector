`default_nettype none

module zeroriscy_vector_alu
(
	input logic [3:0][31:0] argA, argB,
	input logic [3:0] opcode,

	output logic [3:0][31:0] res
);

	always_comb begin
		for (int i = 0; i < 4; i++) begin 
			unique case (opcode)
				ALU_ADD: begin
					res[i] = argA[i] + argB[i];
				end
				ALU_SUB: begin
					res[i] = argA[i] - argB[i];
				end
				ALU_SLL: begin
					res[i] = argA[i] << argB[i][4:0];
				end
				ALU_SRL: begin
					res[i] = argA[i] >> argB[i][4:0];
				end
				ALU_SRA: begin
					res[i] = $signed(argA[i]) >>> argB[i][4:0];
				end
			endcase
	    end
	end

endmodule : zeroriscy_vector_alu