/*

  register_file_tb.v
  
  Tests register_file.v
  
  */

`include "src/defines.v"

module register_file_tb;

reg clk_cpu;
reg reset;
reg [4:0] rd_adrs_a;
reg [4:0] rd_adrs_b;
reg [4:0] wr_adrs;
reg [31:0] wr_data;
reg wr_en;
wire [31:0] q_a;
wire [31:0] q_b;

register_file register_file0(
  .clk_cpu(clk_cpu),
  .reset(reset),
  .rd_adrs_a(rd_adrs_a),
  .rd_adrs_b(rd_adrs_b),
  .wr_adrs(wr_adrs),
  .wr_data(wr_data),
  .wr_en(wr_en),
  .q_a(q_a),
  .q_b(q_b)
);

// clock
initial begin
    clk_cpu = 0;
    forever #`HCYCL clk_cpu = !clk_cpu;
end

// test
integer i, v, old_v;
initial begin
  
  // init regs
  reset = 0;
  
  // tests
  test_reset_button();
  test_sequential_access();
  test_parallel_access();
  test_reset_button();
  
end

// test reset
task test_reset_button;
begin
  
  // reset
  reset = 1;
  repeat(5) @(posedge clk_cpu);
  reset = 0;
  
  // check if cleared
  for (i = 0; i < `N_REGS; i = i + 1) begin
    @(negedge clk_cpu) begin
      rd_adrs_a = i;
      rd_adrs_b = i;
    end
    @(posedge clk_cpu) begin
      if (q_a !== 0) $display("q_a not cleared: %h at %d", q_a, i);
      if (q_b !== 0) $display("q_a not cleared: %h at %d", q_b, i);
    end
  end
end
endtask

// test register file
task test_sequential_access;
begin
  
  // sequential write test
  for (i = 0; i < `N_REGS; i = i + 1) begin
    @(negedge clk_cpu) begin
      wr_adrs = i;
      wr_data = i;
      wr_en = 1;
    end
  end
  
  // sequential read test
  for (i = 0; i < `N_REGS; i = i + 1) begin
    
    // set read addresses
    @(negedge clk_cpu) begin
      rd_adrs_a = i;
      rd_adrs_b = i;
    end

    // check values    
    @(posedge clk_cpu) begin
      if (q_a !== i)
        $display("Unexpected q_a at %d, value: %h", i, q_a);
      if (q_b !== i)
        $display("Unexpected q_b at %d, value: %h", i, q_b);
    end
  end
  
  // clear params
  wr_adrs = 0;
  wr_data = 0;
  wr_en = 0;
  rd_adrs_a = 0;
  rd_adrs_b = 0;
  
end
endtask

task test_parallel_access;
begin
  
  // parallell read and write test
  for (i = 0; i < 32; i = i + 1) begin
    
    // write new value
    @(negedge clk_cpu) begin
      v = $random;
      wr_adrs = i;
      wr_data = v;
      wr_en = 1;
      if (i > 0) begin
        rd_adrs_a = i - 1;
        rd_adrs_b = i - 1;
      end
    end
    
    // check previous values
    @(posedge clk_cpu) begin
      if (i > 0) begin
        if (q_a !== old_v)
          $display("Unexpected q_a at %d, expected: %h, value: %h", i, v, q_a);
        if (q_b !== old_v)
          $display("Unexpected q_b at %d, expected: %h, value: %h", i, v, q_b);
      end
      old_v = v;
    end
  end
  
  // clear write params
  wr_adrs = 0;
  wr_data = 0;
  wr_en = 0;
  rd_adrs_a = 0;
  rd_adrs_b = 0;
  
end
endtask

endmodule