/*
*   Test These Instructments.
*   [R] sub
*   [R] sll
*   [R] or
*   [I] addi
*   [I] slli
*   [I] lw
*   [S] sw
*   [SB] beq
*   [U] auipc (R[rd]=PC+imm)
*   [U] lui   (R[rd]=imm)
*   [UJ] jal  (R[rd]=PC+4)
*   [I]  jalr  (R[rd]=PC+4)
*/


module Control_tb();
reg clk=0;
always begin
    #1 clk=~clk;
end
localparam SUB = 7'b0110011;
localparam SLL = 7'b0110011;
localparam OR = 7'b0110011;
localparam ADDI = 7'b0010011;
localparam SLLI = 7'b0010011;
localparam LW = 7'b0000011;
localparam SW = 7'b0100011;
localparam BEQ = 7'b1100011;
localparam AUIPC = 7'b0010111;
localparam LUI = 7'b0110111;
localparam JAL = 7'b1101111;
localparam JALR = 7'b1100111;

reg [6:0] OPCODE=7'b7f;

wire BRANCH;
wire MEM_READ;
wire [1:0] MEM_TO_REG;
wire [1:0] ALU_OP;
wire MEM_WRITE;
wire ALU_SRC1;
wire ALU_SRC2;
wire REG_WRITE;

Control _inst_test_control(
    OPCODE,
    BRANCH,
    MEM_READ,
    MEM_TO_REG,
    ALU_OP,
    MEM_WRITE,
    ALU_SRC1,
    ALU_SRC2,
    REG_WRITE
);

initial begin
    #10 OPCODE=SUB;
    #10 OPCODE=AUIPC;
    #10 OPCODE=SLLI;
    #10 OPCODE=SLL;
    #5  OPCODE=SW;
    #5  OPCODE=LW;
    #5  OPCODE=LUI;
    #5  OPCODE=ADDI;
    #5  OPCODE=BEQ;
    #5  OPCODE=JAL;
    #5  OPCODE=JALR;
    #5  OPCODE=OR;

    #1000 $finish;
end

initial begin
        $dumpfile("control_tb.vcd");
        $dumpvars(0,Control_tb);
end

endmodule

