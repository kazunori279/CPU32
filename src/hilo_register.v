/*

  hilo_register.sv
  
  Holds hi and lo register values.
  
  */

`include "src/defines.v"

module hilo_register (
  input clk_cpu,
  input reset,
  input wr_en,
  input [63:0] wr_data,
  output [63:0] q
);

  reg [63:0] hilo_reg;

  // reset and write data
  always_ff @(posedge clk_cpu, posedge reset) begin
    if (reset) begin
      hilo_reg <= 64'b0;
    end else 
      if (wr_en)
        hilo_reg <= wr_data;
  end

  // read
  assign q = hilo_reg;

endmodule

