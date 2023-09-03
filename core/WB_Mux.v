module WB_Mux(
    input [1:0] s_mem_to_reg,
    input [31:0] DMem_Out,
    input [31:0] ALU_Result,
    input [31:0] PC,
    input [31:0] Imm_Out,
    output reg [31:0] Data_Out=0
);

always@(*)begin
    case(s_mem_to_reg)
        2'b00:Data_Out<=ALU_Result;
        2'b01:Data_Out<=DMem_Out;
        2'b10:Data_Out<=PC+4;
        2'b11:Data_Out<=Imm_Out;
    endcase
end

endmodule

