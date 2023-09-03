module DMem_tb (
);
reg clk=0;
reg rst_n=1;
reg wen=0;
reg ren=0;
reg [31:0] wd=0;
reg [31:0] addr=0;
wire [31:0] out;
wire rdy;
DMem_Interface _inst_test_dmem(
    clk,
    rst_n,
    wen,
    ren,
    wd,
    addr,
    out,
    rdy
);
initial begin
        $dumpfile("DMem_tb.vcd");
        $dumpvars(0,DMem_tb);
end
always #1 clk=~clk;

initial
begin
    #1
    rst_n<=0;
    #1
    rst_n<=1;
    // write
    #2 addr<=32'd8;
    wd  <=32'd100;
    #1 wen<=1;
    #2 wen<=0;

    //read
    #2 addr<=32'd8;
    #2 ren <= 1;
    #2 ren <= 0;
    #10 $finish;
end

endmodule
