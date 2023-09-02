module Cache_tb();

reg clk=0;
reg pc_clk=0;
always #1 clk=~clk;
always #5 pc_clk=~pc_clk;
wire [31:0] PC;
PC_Control _instr_test_PC(
    pc_clk,
    2'b00,
    1'b0,
    32'd0,
    32'd0,
    PC
);
wire[31:0]INSTR;
wire rdy;
IMem_Interface _inst_imem(
    clk,
    PC,
    rdy,
    INSTR
);

initial
begin

    #1000 $finish;
end

initial begin
        $dumpfile("i_cache_tb.vcd");
        $dumpvars(0,Cache_tb);
end

endmodule
