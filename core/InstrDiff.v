//根据输入的instr[6:0] 区分 R type/I type/ U type/ UJ type/ S type/ SB type
module InstrDiff(
    input [6:0] instr_op,
    output  reg  [2:0]sel
);

always@(*)begin
    if(instr_op[6:2]==5'b00000||instr_op[6:2]==5'b00100||instr_op[6:2]==5'b00110||instr_op[6:2]==5'b11001||instr_op[6:2]==5'b11100)
    begin
        sel <= 3'b000;   //I type.
    end
    else if(instr_op[6:2]==5'b00101||instr_op[6:2]==5'b01101)begin
        sel <= 3'b001;   //U type
    end
    else if(instr_op[6:2]==5'b11011) begin
        sel <= 3'b010;   // UJ
    end
    else if(instr_op[6:2]==5'b01000) begin
        sel <= 3'b011;   //S
    end
    else if(instr_op[6:2]==5'b11000) begin
        sel <= 3'b100;  //SB
    end
    else if(instr_op[6:2]==5'b01100||instr_op[6:2]==5'b01110) begin
        sel <= 3'b101;         //R
    end
    else begin
        sel <= 3'b111;  //Unknown.
    end
end
endmodule
