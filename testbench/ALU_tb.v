module ALU_tb();
reg clk=0;
always begin
    #1 clk = ~clk;
end

reg [31:0] num1;
reg [31:0] num2;
wire [31:0] out;
reg [1:0] alu_op=2'b11;
reg [4:0] op_func;
wire b_succuss;

ALU _inst_test_ALU(
    alu_op,
    op_func,
    num1,
    num2,
    out,
    b_succuss
);

//  Test  these  operations:
//  num1 and num2  all signed.
//  add  32'd 200 + 32'd 12000
//  add  32'h 7fffffff +  32'h1
//  sub  32'd 1000 - 32'd  112
//  addi  32'd 500 + 32'd -1000
//  sub  32'd 1    - 32'd 9

//  sll  32'h 00007fff << 0
//  sll  32'h 00007fff << 31

//  srl  32'h 7fff0000 >> 4
//  srl  32'h 8fff0000 >> 12

//  sra  32'h 7000ffff >> 5
//  sra  32'h 8000ffff >> 31

//  and  32'h ffff0000 &  32'hf0000000
//  or   32'h 0000ffff |  32'hffff0000
//  xor  32'h f0f00f0f ^  32'hffffffff

initial begin
    #10 op_func <= 5'b10000;
    num1 <= 32'd200;
    num2 <= 32'd12000;
    #10 op_func <= 5'b10000;
    num1 <= 32'h7fffffff;
    num2 <= 32'd1;
    #10 op_func <= 5'b11000;
    num1 <= 32'd1000;
    num2 <= 32'd112;
    #10 op_func <= 5'b00000;
    num1 <= 32'd500;
    num2 <= -32'd1000;
    #10 op_func <= 5'b11000;  //sub 1 , 9
    num1 <= 32'd1;
    num2 <= 32'd9;
    //sll
    #10 op_func <= 5'b10001;
    num1 <= 32'h00007fff;
    num2 <= 32'd0;
    //sll 31
    #10 op_func <= 5'b10001;
    num1 <= 32'h00007fff;
    num2 <= 32'd31;
    //srl 4
    #10 op_func <= 5'b10101;
    num1 <= 32'h00007fff;
    num2 <= 32'd4;
    //srl
    #10 op_func <= 5'b10101;
    num1 <= 32'h00007fff;
    num2 <= 32'd12;

    //sra
    #10 op_func <= 5'b11101;
    num1 <= 32'h7000ffff;
    num2 <= 32'd5;

    //sra
    #10 op_func <= 5'b01101;
    num1 <= 32'hf000ffff;
    num2 <= 32'd31;

    //and
    #10 op_func <= 5'b01111;
    num1 <= 32'hffff0000;
    num2 <= 32'hf0000000;

    //or
    #10 op_func <= 5'b00110;
    num1 <= 32'h0000ffff;
    num2 <= 32'hffff0000;

    //xor
    #10 op_func <= 5'b10100;
    num1 <= 32'hf0f00f0f;
    num2 <= 32'hffffffff;

//  beq  32'hffffffff == 32'hffffffff    T
//  beq  -32'd1 == 32'd1                 F

//  blt  32'd50 <  32'd51                T
//  blt  32'd52 <  32'd50                F

//  bge  32'd0 >= 32'd0                  T
//  bge  32'hfffffff0 >=  32'hffffffff   F

    //beq
    #10
    op_func <= 5'b10000;
    num1 <= 32'hffffffff;
    num2 <= 32'hffffffff;
    #10
    op_func <= 5'b10000;
    num1 <= -32'd1;
    num2 <=  32'd1;

    //blt
    #10
    op_func <= 5'b11100;
    num1 <= 32'd50;
    num2 <= 32'd51;
    #10
    op_func <= 5'b11100;
    num1 <= 32'd52;
    num2 <= 32'd50;

    //bge
    #10
    op_func <= 5'b10101;
    num1 <= 32'd0;
    num2 <= 32'd0;
    #10
    op_func <= 5'b10101;
    num1 <= 32'hfffffff0;
    num2 <= 32'hffffffff;

    #100 $finish;
end

initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0,ALU_tb);
end


endmodule
