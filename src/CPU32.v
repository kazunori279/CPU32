/*
 
  CPU32.v
  
  The top level module.
  
 */

`include "src/defines.v"

module CPU32 (
  input   clk,
  input   btn0_n,
  input   [9:0] sw,
  output  [7:0] led0_n,
  output  [7:0] led1_n,
  output  [7:0] led2_n,
  output  [7:0] led3_n
);

  // reset signal
  wire reset;
  chattering_canceler chattering_canceler0(
    .clk(clk), 
    .dat_in_n(btn0_n), 
    .dat_out(reset)
  );

  // cpu clock prescaling
  wire clk_cpu, clk_stp, clk_ram;
  clock_prescaler clock_prescaler0(
    .clk(clk), 
    .clk_cpu(clk_cpu),
    .clk_stp(clk_stp),
	 .clk_ram(clk_ram)
  );

  // CPU
  wire [31:0] pc, inst, dbg_reg_q, dbg_led_q;
  wire [4:0] dbg_reg_adrs = sw[4:0];
  CPU CPU0(
    .clk_cpu(clk_cpu),
	  .clk_ram(clk_ram),
    .reset(reset),
	  .dbg_reg_adrs(dbg_reg_adrs),
	  .dbg_sw_input(sw[3:0]),
	  .pc(pc),
	  .inst(inst),
	  .dbg_reg_q(dbg_reg_q),
	  .dbg_led_q(dbg_led_q)
  );
  
  // LED display to show $7ff0, pc or registers
  // sw9: off = $7ff0, on = pc or reg
  // sw8: off = pc, on = reg
  // sw7: off = [15:0], on = [31:16]
  // sw4-0: reg adrs
  wire [31:0] led_out_full = sw[9:9] ? (sw[8:8] ? dbg_reg_q : pc) : dbg_led_q;
  wire [15:0] led_out_half = sw[7:7] ? led_out_full[31:16] : led_out_full[15:0]; 
  led_decoder led_decoder0(led_out_half[3:0], clk_cpu, 1'b1, led0_n);
  led_decoder led_decoder1(led_out_half[7:4], 1'b0, 1'b1, led1_n);
  led_decoder led_decoder2(led_out_half[11:8], 1'b0, 1'b1, led2_n);
  led_decoder led_decoder3(led_out_half[15:12], 1'b0, 1'b1, led3_n);
  
endmodule