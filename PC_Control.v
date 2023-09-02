module PC_Control(
    input clk,
    input [1:0] PC_Sel,  //branch:PC=PC+Imm.  jal:PC=PC+imm.  jalr:PC=R_rs1+Imm
    // if PC_Sel==00(default),PC=PC+4.  else if 01: branch PC = PC + Imm or PC + 4 else if 10: PC=PC+Imm.
    // 11:PC=R_rs1+Imm.
    input s_branch, //if 1,branch jump.
    input [31:0]  Imm,
    input [31:0] R_rs1,
    output reg [31:0] PC=0
);

always @(posedge clk) begin
    case(PC_Sel)
        2'b00:begin
            PC<=PC+4;
        end
        2'b01:begin
            PC<=(s_branch)?PC+Imm:PC+4;
        end
        2'b10:begin
            PC<=PC+Imm;
        end
        2'b11:begin
            PC<=R_rs1+Imm;
        end
    endcase
end

endmodule

