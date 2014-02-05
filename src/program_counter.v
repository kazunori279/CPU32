/*

  program_counter.v
  
  Holds Program Counter and branch logic.
  
  */

`include "src/defines.v"

module program_counter (
  input   clk_cpu,
  input   reset,
  input [31:0] inst,
  input [`CPATH] cpath,
  input [63:0] alu_result,
  output reg [31:0] pc
);

  // calculate addresses
  wire [31:0] jmp_addr, brnc_addr, next_addr;
  assign next_addr = pc + 32'd4;
  assign jmp_addr = inst[`I_ADDR] << 2;
  assign brnc_addr = {{14{inst[15]}}, inst[`I_IMM], 2'b00} + next_addr; // sign extended imm + 2 bit shift
  
  // program counter and branch logic
  always_ff @(posedge clk_cpu, posedge reset) begin
    if (reset) begin
      pc <= `ADRS_TEXT_START;
    end else begin
      if (cpath[`CP_EXCP] || pc === `ADRS_EXCP || pc[1:0] !== 2'b00) // cpu halt
        pc <= `ADRS_EXCP;
      else begin
        case (inst[`I_OP])
          `OP_R:
            case (cpath[`CP_ALU_CTRL])
              `R_jr:    pc <= alu_result[63:32];
              `R_jalr:  pc <= alu_result[63:32];
              default:  pc <= next_addr;
            endcase
          `OP_bltz: 
            case (inst[`I_RT])
              0:  pc <= $signed(alu_result) < 0 ? brnc_addr : next_addr;
              1:  pc <= $signed(alu_result) >= 0 ? brnc_addr : next_addr;
            endcase
          `OP_beq:  pc <= alu_result === 64'd0 ? brnc_addr : next_addr;
          `OP_bne:  pc <= alu_result !== 64'd0 ? brnc_addr : next_addr;
          `OP_blez: pc <= $signed(alu_result) <= 0 ? brnc_addr : next_addr;
          `OP_bgtz: pc <= $signed(alu_result) > 0 ? brnc_addr : next_addr;
          `OP_j:    pc <= {pc[31:28], jmp_addr[27:0]};
          `OP_jal:  pc <= {pc[31:28], jmp_addr[27:0]};
          default:  pc <= next_addr;
        endcase
      end
    end
  end

endmodule
