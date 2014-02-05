/*

  chattering_canceler.v 

  Removes chattering from dat_in with 16 bit shift register, and negates the value.
  
*/

module chattering_canceler (
	input 	clk,
	input 	dat_in_n,
	output  dat_out
);

  reg [15:0] buffer = 16'hFFFF;

  always @(posedge clk) begin
    buffer = { buffer[14:0], dat_in_n };
  end
  
  assign dat_out = (buffer == 16'h0000);

endmodule