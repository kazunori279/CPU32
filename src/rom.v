/*

  rom.v
  
  Represents an instruction rom for debug purpose.
  
  */

`include "src/defines.v"

module rom (
	input [31:0] pc,
	output reg [31:0] inst
);

	always_comb begin
		case (pc)
	
			default: 	inst = 32'h00000000;
		endcase
	end

endmodule
