/*

  register_file.v
  
  Represents a tri-port RAM for holding 32 register values.
  
  */

`include "src/defines.v"

module register_file (
  input clk_cpu,
  input reset,
  input [4:0] rd_adrs_a,
  input [4:0] rd_adrs_b,
  input [4:0] rd_adrs_c,  
  input [4:0] wr_adrs,
  input [31:0] wr_data,
  input wr_en,
  output [31:0] q_a,
  output [31:0] q_b,
  output [31:0] q_c
);

  // registers
  reg [31:0] regs[0:`N_REGS - 1];

  // reset and write data
  integer i;  
  always_ff @(posedge clk_cpu, posedge reset) begin
    if (reset) begin
      for (i = 0; i < `N_REGS; i = i + 1) begin
        if (i == 31) regs[i] <= `ADRS_EXCP; // set $ra initial value
        else if (i == 29) regs[i] <= `ADRS_STCK_END; // set $sp initial value
        else regs[i] <= 32'd0;
      end
    end else 
      if (wr_en && wr_adrs !== 5'd0) // you can't write to $0
        regs[wr_adrs] <= wr_data;
  end

  // read ports  
  assign q_a = regs[rd_adrs_a];
  assign q_b = regs[rd_adrs_b];
  assign q_c = regs[rd_adrs_c];
  
endmodule