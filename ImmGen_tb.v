module ImmGen_tb();
reg clk = 0;

always  begin
    #1 clk=~clk;
end
reg [31:0] input_instr=0;
wire [31:0] output_imm;
ImmGen _test_inst_ImmGen(
    input_instr,
    output_imm
);

initial begin
        #10   input_instr = 32'b0110_0111_1111_0000_0000_0000_0001_0011;   // I type. Imm(12bit)->67f
        #10   input_instr = 32'b1000_1111_1111_1111_1010_0000_0011_0111;   // U type.  Imm->8fffa000
        #10   input_instr = 32'b0111_0111_1001_0111_1111_0000_0110_1111;   // UJ type. Imm->0007ff78 0 0111 1111 1111 0111 1000
        #10   input_instr = 32'b0110_0110_0000_0000_0000_1111_1010_0011;   // S type. Imm->67f
        #10   input_instr = 32'b0110_1100_0000_0000_0000_1000_1110_0011;   // SB type. imm-> 12bit 768  0111 0110 1000


        #1000 $finish;
end

initial begin
        $dumpfile("immgen_tb.vcd");
        $dumpvars(0,ImmGen_tb);
end

endmodule
