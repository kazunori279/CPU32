/*
 
  CPU32_tb.v
  
  Tests CPU32.v
  
 */

`include "src/defines.v"

module CPU32_tb;

reg clk;
reg btn0_n;

// CPU instance
CPU32 CPU32_0(
  .clk(clk),
  .btn0_n(btn0_n)
);

// clock
initial begin
    clk = 0;
    forever #`HCYCL clk = !clk;
end

// test
initial begin
  
  // init regs
  btn0_n = 1;
  
  // reset
  test_reset_button();
  
end

// tasks
task test_reset_button;
begin
  btn0_n = 0;
  repeat(20) @(posedge clk);
  btn0_n = 1;
end
endtask

endmodule