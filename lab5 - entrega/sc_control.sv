`timescale 1ns / 1ps

module sc_control (
    input  logic [6:0] Opcode,
    output logic       ALUSrc,
    output logic       MemtoReg,
    output logic       RegWrite,
    output logic       MemRead,
    output logic       MemWrite,
    output logic       Branch,
    output logic [1:0] ALUOp
);

    localparam R_TYPE = 7'b0110011; // add, sub, and, or, slt
    localparam LOAD   = 7'b0000011; // lw
    localparam STORE  = 7'b0100011; // sw
    localparam BRANCH = 7'b1100011; // beq

    always_comb begin
        ALUSrc   = 1'b0;
        MemtoReg = 1'b0;
        RegWrite = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        Branch   = 1'b0;
        ALUOp    = 2'b00;

        case (Opcode)
            R_TYPE: begin
                ALUSrc   = 1'b0;   // operandos vêm de rs1/rs2
                MemtoReg = 1'b0;   // resultado da ALU
                RegWrite = 1'b1;   // escreve em rd
                ALUOp    = 2'b10;  // ALU Control decodifica funct3/funct7
            end

            LOAD: begin
                ALUSrc   = 1'b1;   // rs1 + imediato
                MemtoReg = 1'b1;   // dado vem da memória
                RegWrite = 1'b1;   // escreve em rd
                MemRead  = 1'b1;
                ALUOp    = 2'b00;  // força ADD
            end

            STORE: begin
                ALUSrc   = 1'b1;   // rs1 + imediato
                MemWrite = 1'b1;
                ALUOp    = 2'b00;  // força ADD
            end

            BRANCH: begin
                ALUSrc = 1'b0;     // compara rs1 com rs2
                Branch = 1'b1;
                ALUOp  = 2'b01;    // força SUB (Zero indica igualdade)
            end

            default: ;
        endcase
    end

endmodule
