/*

  ram.v
  
  Represents a memory controller for BRAM. Provides functions like:
  - read an instruction at PC address
  - decode the instruction to control the following RAM access
  -- read/write data at specified address 
  -- byte alighment and mask for byte/half-word load/store instructions
  
  - Memory map: 
  -- 0x0000 ->        : text
  --        <- 0x7efc : stack
  -- 0x7f00 -- 0x7fff : global
  -- 0x7f00 : to display result on LED 
  -- 0x7ff0 : to input params from sw3 - sw0
  
  */

`include "src/defines.v"

module ram (
  input clk_cpu,
  input clk_ram,
  input reset,
  input [31:0] pc,
  input [31:0] adrs,
  input [31:0] data,
  input [3:0] dbg_sw_input,
  output reg [31:0] inst,
  output reg [31:0] q,
  output reg [31:0] dbg_led_q
);

  // memory access controls
  `define MEM_SIGN    0:0
  `define MEM_SIGN_F  1'b0
  `define MEM_SIGN_T  1'b1
  `define MEM_WIDTH   2:1
  `define MEM_WIDTH_W 2'b00
  `define MEM_WIDTH_H 2'b01
  `define MEM_WIDTH_B 2'b10
  `define MEM_RW      3:3
  `define MEM_RW_R    1'b0
  `define MEM_RW_W    1'b1
  
  // read and decode an instruction
  reg [3:0] mem_ctrl;
  always_comb begin
    case(inst[`I_OP])
      `OP_lb:   mem_ctrl = {`MEM_RW_R, `MEM_WIDTH_B, `MEM_SIGN_T};
      `OP_lh:   mem_ctrl = {`MEM_RW_R, `MEM_WIDTH_H, `MEM_SIGN_T};
      `OP_lw:   mem_ctrl = {`MEM_RW_R, `MEM_WIDTH_W, `MEM_SIGN_T};
      `OP_lbu:  mem_ctrl = {`MEM_RW_R, `MEM_WIDTH_B, `MEM_SIGN_F};
      `OP_lhu:  mem_ctrl = {`MEM_RW_R, `MEM_WIDTH_H, `MEM_SIGN_F};
      `OP_sb:   mem_ctrl = {`MEM_RW_W, `MEM_WIDTH_B, `MEM_SIGN_F};
      `OP_sh:   mem_ctrl = {`MEM_RW_W, `MEM_WIDTH_H, `MEM_SIGN_F};
      `OP_sw:   mem_ctrl = {`MEM_RW_W, `MEM_WIDTH_W, `MEM_SIGN_F};
      default:  mem_ctrl = {`MEM_RW_R, `MEM_WIDTH_W, `MEM_SIGN_T};
    endcase
  end
  
  // read data alignment and sign extension
  wire [31:0] bram_q;
  wire [29:0] word_adrs = adrs[31:2];
  wire [31:0] aligned_rd_data = bram_q >> $unsigned(
    adrs[1:0] === 2'b00 ? 0 :    
    adrs[1:0] === 2'b01 ? 8 :
    adrs[1:0] === 2'b10 ? 16 : 24);
  assign q =
    adrs === `ADRS_DBG_SW ? {24'b0, dbg_sw_input} :
    mem_ctrl[`MEM_WIDTH] === `MEM_WIDTH_W ? aligned_rd_data :
    mem_ctrl[`MEM_WIDTH] === `MEM_WIDTH_H ? {{16{aligned_rd_data[15] & mem_ctrl[`MEM_SIGN]}}, aligned_rd_data[15:0]} :
    mem_ctrl[`MEM_WIDTH] === `MEM_WIDTH_B ? {{24{aligned_rd_data[7] & mem_ctrl[`MEM_SIGN]}}, aligned_rd_data[7:0]} :
    32'b0;

  // write data alignment
  wire [31:0] aligned_wr_data = data << $unsigned(
    adrs[1:0] === 2'b00 ? 0 :
    adrs[1:0] === 2'b01 ? 8 : 
    adrs[1:0] === 2'b10 ? 16 : 24);
    
  // byte enable calculation
  wire wr_en = mem_ctrl[`MEM_RW] === `MEM_RW_W;
  reg [3:0] bt_en;
  always_comb begin
    if (wr_en)
      case (mem_ctrl[`MEM_WIDTH])
        `MEM_WIDTH_W : bt_en = 4'b1111;
        `MEM_WIDTH_H : bt_en = (adrs[1:0] === 2'b00) ? 4'b0011 : 4'b1100;
        `MEM_WIDTH_B : bt_en =
          	adrs[1:0] === 2'b00 ? 4'b0001 :
          	adrs[1:0] === 2'b01 ? 4'b0010 : 
          adrs[1:0] === 2'b10 ? 4'b0100 : 4'b1000;
        default: bt_en = 4'b1111;
      endcase
    else
      bt_en = 4'b1111;
  end
  
  // debug LED output
  always_ff @(posedge clk_cpu, posedge reset) begin
      if (reset)
        dbg_led_q <= 32'b0;
      else if (wr_en && adrs === `ADRS_DBG_LED)
        dbg_led_q <= data;
  end

  // BRAM (port_a = PC/inst, port_b = rd/wr)
  bram bram0 (
    .address_a(pc[14:2]),
	  .address_b(word_adrs[12:0]),
	  .byteena_a(4'b0),
	  .byteena_b(bt_en),	
	  .clock(clk_ram),
	  .data_a(32'b0),
	  .data_b(aligned_wr_data),
	  .wren_a(1'b0),
	  .wren_b(wr_en),
	  .q_a(inst),
	  .q_b(bram_q)
  );
  
endmodule
