/*
 * clock_prescaler.v
 */

`include "src/defines.v"

module clock_prescaler (
  input   clk,
  output  reg clk_cpu,
  output  reg clk_stp,
  output  reg clk_ram
);

  reg [31:0] cnt = 32'd0;
  always @(posedge clk) begin
    if (cnt == `CPU_CLK_PRESCALE) begin
      cnt <= 32'd0;
    end else begin
      cnt <= cnt + 32'd1;
    end
  end

  reg clk_base;
  always @(posedge clk) begin
    clk_base <= cnt < (`CPU_CLK_PRESCALE / 2);
  end
  assign clk_ram = ~clk_base;
  
  // clk_cpu register (clock for cpu)
  always @(posedge clk_base) begin
    clk_cpu <= ~clk_cpu;
  end
  
  // clk_stp register (clock for SignalTap)
  always @(posedge clk) begin
    clk_stp <= cnt[20:20];
  end
  
endmodule