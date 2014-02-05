/*

  defines.v
  
  Holds define statements.
  
 */

// CPU clock prescaling 
//`define CPU_CLK_PRESCALE 32'd4999999 // (10 cycle per sec)
`define CPU_CLK_PRESCALE 32'd9

// timing definitions for tests  
`timescale 1ns/1ns
`define CYCLE 20
`define HCYCL 10
`define MCYCL 5		// half cycle for BRAM
`define DELAY 2
`define STROB 18
`define HSTRB 8

// number of registers
`define N_REGS 32

// memory mappings
`define ADRS_TEXT_START	32'h00000000
`define ADRS_STCK_END	32'h00007efc
`define ADRS_GLBL_START	32'h00007f00
`define ADRS_DBG_LED	32'h00007f00
`define ADRS_DBG_SW		32'h00007ff0
`define ADRS_EXCP 		32'hfffffff0

//
// Instruction Encodings
//

// common encodings
`define I_OP    31:26
`define I_RS    25:21
`define I_RT    20:16

// R-type encodings
`define I_RD    15:11
`define I_SHFT  10:6
`define I_FUNC  5:0

// I-type encodings
`define I_IMM   15:0

// J-type encodings
`define I_ADDR  25:0

// opcodes
`define OP_R      6'b000000
`define OP_bltz   6'b000001
`define OP_j      6'b000010
`define OP_jal    6'b000011
`define OP_beq    6'b000100
`define OP_bne    6'b000101
`define OP_blez   6'b000110
`define OP_bgtz   6'b000111
`define OP_addi   6'b001000
`define OP_addiu  6'b001001
`define OP_slti   6'b001010
`define OP_sltiu  6'b001011
`define OP_andi   6'b001100
`define OP_ori    6'b001101
`define OP_xori   6'b001110
`define OP_lui    6'b001111
`define OP_mfc0   6'b010000
`define OP_F      6'b010001
`define OP_lb     6'b100000
`define OP_lh     6'b100001
`define OP_lw     6'b100011
`define OP_lbu    6'b100100
`define OP_lhu    6'b100101
`define OP_sb     6'b101000
`define OP_sh     6'b101001
`define OP_sw     6'b101011
`define OP_lwcl   6'b101001
`define OP_swcl   6'b111001

// R-type instructions
`define R_sll     6'b000000
`define R_srl     6'b000010
`define R_sra     6'b000011
`define R_sllv    6'b000100
`define R_srlv    6'b000110
`define R_srav    6'b000111
`define R_jr      6'b001000
`define R_jalr    6'b001001
`define R_syscall 6'b001100
`define R_break   6'b001101
`define R_mfhi    6'b010000
`define R_mthi    6'b010001
`define R_mflo    6'b010010
`define R_mtlo    6'b010011
`define R_mult    6'b011000
`define R_multu   6'b011001
`define R_div     6'b011010
`define R_divu    6'b011011
`define R_add     6'b100000
`define R_addu    6'b100001
`define R_sub     6'b100010
`define R_subu    6'b100011
`define R_and     6'b100100
`define R_or      6'b100101
`define R_xor     6'b100110
`define R_nor     6'b100111
`define R_slt     6'b101010
`define R_sltu    6'b101011

// R-type internal insts
`define R_lui     6'b111001

// F-type instructions
// TODO

//
// Control Path encodings
//

`define CP_START        0
`define CP_EXCP_LSB     `CP_START
`define CP_EXCP         `CP_EXCP_LSB:`CP_EXCP_LSB
`define CP_ALU_SRC_LSB  `CP_EXCP_LSB + 1
`define CP_ALU_SRC      `CP_ALU_SRC_LSB + 1:`CP_ALU_SRC_LSB
`define CP_ALU_CTRL_LSB `CP_ALU_SRC_LSB + 2
`define CP_ALU_CTRL     `CP_ALU_CTRL_LSB + 5:`CP_ALU_CTRL_LSB
`define CP_REG_WR_LSB   `CP_ALU_CTRL_LSB + 6
`define CP_REG_WR       `CP_REG_WR_LSB:`CP_REG_WR_LSB
`define CP_REG_DST_LSB  `CP_REG_WR_LSB + 1
`define CP_REG_DST      `CP_REG_DST_LSB + 1:`CP_REG_DST_LSB
`define CP_REG_SRC_LSB  `CP_REG_DST_LSB + 2
`define CP_REG_SRC      `CP_REG_SRC_LSB + 1:`CP_REG_SRC_LSB
`define CP_END          `CP_REG_SRC_LSB + 1
`define CPATH           `CP_END:`CP_START

// REG_WR: write to the destination register if true
`define REG_WR_F      1'b0
`define REG_WR_T      1'b1

// REG_DST: the destination register (rt or rd)
`define REG_DST_RT    2'b00
`define REG_DST_RD    2'b01
`define REG_DST_31    2'b10

// REG_SRC: the source (alu or ram) to write to the destination register
`define REG_SRC_ALU   2'b00
`define REG_SRC_RAM   2'b01
`define REG_SRC_PC    2'b10

// ALU_SRC: the source (a register, immediate signed or immediate unsigned) to pass to ALU
`define ALU_SRC_REG   2'b00
`define ALU_SRC_IMM   2'b01
`define ALU_SRC_IMU   2'b10

// EXCP: stop the CPU if true
`define EXCP_F         1'b0
`define EXCP_T         1'b1

