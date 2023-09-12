module PLRU_tb();
reg clk=0;
reg rst_n=1;
reg miss=0;
reg hit=0;
reg [2:0] hit_ptr=0;
reg [2:0] index=0;
wire [2:0] way;

always #1 clk=~clk;

PLRU _inst_test_plru(
    clk,
    rst_n,
    miss,
    hit,
    hit_ptr,
    index,
    way
);
initial begin
    rst_n=0;
    #2 rst_n=1;
    #4 miss=1;
    index=0;
    #4 miss=0;

    #4 miss=1;
    index=0;
    #4 miss=0;

    #4 miss=1;
    index=0;
    #4 miss=0;

    #4 miss=1;
    index=0;
    #4 miss=0;

    #4 miss=1;
    index=0;
    #4 miss=0;

    #4 miss=1;
    index=0;
    #4 miss=0;

    #4 miss=1;
    index=0;
    #4 miss=0;

    #4 miss=1;
    index=0;
    #4 miss=0;

    #4 miss=1;
    index=0;
    #4 miss=0;

    #4 hit=1;
    index=0;
    hit_ptr=6;
    #4 hit=0;

    #4 miss=1;
    index=0;
    #4 miss=0;

    #10 $finish;
end
initial begin
        $dumpfile("plru_tb.vcd");
        $dumpvars(0,PLRU_tb);
end

endmodule
