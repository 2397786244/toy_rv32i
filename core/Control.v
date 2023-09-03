//Generate  Branch/MemRead/MemToReg/ALUOp/MemWrite/ALUSrc/Reg Signals.
module Control(
    input [6:0] opcode,
    output reg s_branch=0,
    output reg s_mem_read=0,   // if 1,read Mem and write to RegFile,else write the result of ALU to RegFile.
    output reg [1:0] s_mem_to_reg=0,  //if mem_to_reg==2,write PC+4 into reg.
    output reg [1:0] s_alu_op=2'b0,   //00->R type I type | 01 add : Load(I) Store(SB) auipc(UJ)  | 10 no operation (lui) jal(UJ) jalr(I) | 11: branch sub
    output reg s_mem_write=0,
    output reg s_alu_src1=0,  //0->rs1 1->PC(auipc)
    output reg s_alu_src2=0,  //0->rs2 1->Imm
    output reg s_reg_write=0,
    output reg [1:0]  s_pc_sel=0  //00->PC=PC+4  01->branch  10->PC=PC+Imm(jal) 11->PC=R[rs1]+Imm(jalr)
);

wire [2:0] opcode_sel;

InstrDiff _get_opcode_sel(
    opcode,
    opcode_sel
);

always@(*)begin
    if(opcode_sel==3'b100)begin
        s_pc_sel<=2'b01;
    end
    else if(opcode_sel==3'b010) begin
        s_pc_sel<=2'b10;
    end
    else if(opcode[6:2]==5'b11001) begin
        s_pc_sel<=2'b11;
    end
    else begin
        s_pc_sel<=2'b00;
    end
end

// generate branch
always @(*) begin
    if(opcode_sel==3'b100) begin
        s_branch<=1;
    end
    else begin
        s_branch<=0;
    end
end

//for load
always@(*)begin
    if(opcode[6:2]==5'b00000)
    begin
        s_mem_read<=1;
    end
    else begin
        s_mem_read<=0;
    end
end

// s_mem_to_reg Load/jal jalr  00->ALU result. 01->MEM Output.(load) 10->PC+4(jal jalr)  11->Imm(lui)
always@(*)begin
    if(opcode[6:2]==5'b00000)begin
        s_mem_to_reg<=2'b01;
    end
    else if(opcode[6:2]==5'b11001||opcode[6:2]==5'b11011)begin
        s_mem_to_reg<=2'b10;
    end
    else if(opcode[6:2]==5'b01101)begin
        s_mem_to_reg<=2'b11;
    end
    else begin
        s_mem_to_reg<=2'b00;
    end
end

always@(*)begin
    if(opcode_sel==3'b011)begin   //Stype.
        s_mem_write<=1;
    end
    else begin
        s_mem_write<=0;
    end
end

always@(*)begin
    if(opcode_sel==3'b101 || opcode_sel==3'b100) begin   //Rtype,SB type use rs2
        s_alu_src2<=0;//not use ImmGen.
    end
    else begin
        s_alu_src2<=1;
    end
end

always@(*)begin   //auipc->00101
    if(opcode[6:2]==5'b00101)begin
        s_alu_src1<=1;
    end
    else begin
        s_alu_src1<=0;
    end
end

always@(*)begin    // set 1 if opcode is R type\ U type\ I type\UJ
    if(opcode_sel==3'b011||opcode_sel==3'b100)begin
        s_reg_write<=0;
    end
    else begin
        s_reg_write<=1;
    end

end

always@(*)begin
    if(opcode_sel==3'b100) begin
        //branch
        s_alu_op<=2'b11;
    end
    else if(opcode[6:2]==5'b01101 || opcode[6:2] == 5'b11001 || opcode_sel==3'b010) begin
        s_alu_op<=2'b10;
    end
    else if(opcode[6:2]==5'b00000 || opcode_sel==3'b011 || opcode[6:2] == 5'b00101) begin
        s_alu_op<=2'b01;
    end
    else if(opcode_sel==3'b000||opcode_sel==3'b101) begin
        s_alu_op<=2'b00;
    end
    else begin
        s_alu_op<=2'b10;
    end
end

endmodule

