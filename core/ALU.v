module ALU(
    input [1:0] alu_op,
    input [4:0] op_func,   //FUNC3 + FUNC7[5] + OPCODE[5] -> aka {OPCODE[5],instr[30],instr[14:12]}
    input [31:0] d1,
    input [31:0] d2,
    output reg[31:0] dout,
    output reg   b_success=0
);

reg is_add=0;
reg is_sub=0;
reg is_sll=0;
reg is_srl=0;
reg is_sra=0;
reg is_or=0;
reg is_and=0;
reg is_xor=0;

always @(*) begin
    is_add<=0;
    is_sub<=0;
    is_sll<=0;
    is_srl<=0;
    is_sra<=0;
    is_or<=0;
    is_and<=0;
    is_xor<=0;
    if(alu_op==2'b00)begin
        case(op_func[2:0])
            3'b000: //if R type(op_func[4]=1),op_func[3]=1(sub) op_func[3]=0(add)
                    //if I type(op_func[4]=0),is addi.
                    begin
                         is_add <= (op_func[4]==0 || op_func[4:3] == 2'b10) ? 1 : 0;
                         is_sub <= (op_func[4:3]==2'b11) ? 1 : 0;
                    end
            3'b001: is_sll<=1;
            3'b100: is_xor<=1;
            3'b101: begin if(op_func[3]) is_sra<=1; else  is_srl<=1;  end
            3'b110: is_or<=1;
            3'b111: is_and<=1;
        endcase
    end
    else if(alu_op==2'b01)begin
        is_add<=1;
    end
    else if(alu_op==2'b11)begin
        is_sub<=1;
    end
end

always@(*)begin
    if(is_add)      dout <= $signed(d1) + $signed(d2);
    else if(is_and) dout <= d1 & d2;
    else if(is_or)  dout <= d1 | d2;
    else if(is_sll) dout <= d1 << d2;
    else if(is_sra) dout <= $signed(d1) >>> d2;
    else if(is_srl) dout <= d1 >> d2;
    else if(is_sub) dout <= $signed(d1) - $signed(d2);
    else if(is_xor) dout <= d1 ^ d2;
end

reg b_lt=0;
reg b_ge=0;
reg b_eq=0;
//branch judge.
always@(*)begin
    if(alu_op==2'b11)
    begin
        if(dout==0)begin
            b_eq<=1;
        end
        else b_eq <= 0;

        if(dout[31]==1'b1)begin
            b_lt<=1;
        end
        else b_lt <= 0;

        if(dout[31]==0&&dout>=0) b_ge <= 1;
        else  b_ge <= 0;
    end
    else begin
        b_eq<=0;
        b_lt<=0;
        b_ge<=0;
    end

end

always@(*)
begin
    if(op_func[2:0]==3'b000)begin
        b_success<=b_eq;
    end
    else if(op_func[2:0]==3'b100)begin
        b_success<=b_lt;
    end
    else if(op_func[2:0]==3'b101)begin
        b_success<=b_ge;
    end
    else b_success<=0;
end

endmodule

