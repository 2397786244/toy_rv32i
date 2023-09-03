module RegFile_tb();
reg clk=0;
always begin
    #1 clk=~clk;
end

reg [4:0] rs1=0;
reg [4:0] rs2=0;
reg [4:0] rd=0;
wire [31:0] R1;
wire [31:0] R2;
reg    wen=0;
reg [31:0] Rd_dat=0;
reg rst_n=1;

RegFile _inst_regfile(
    clk,
    rst_n,
    rs1,
    rs2,
    rd,
    R1,
    R2,
    wen,
    Rd_dat
);

initial begin
    // read x0,x1 -> x3
    #2 rst_n<=0;
    #2 rst_n<=1;
    #2 rs1<=0;
       rs2<=0;
       rd<=3;
    #1 Rd_dat<=32'd1000;
    #2 wen<=1;
    #2 wen<=0;

    #4 rs1<=3;
       rs2<=1;
       rd<=1;
    #1 Rd_dat<=32'd1;
    #1 wen<=1;
    #2 wen<=0;

    #4 rs1<=0;
       rs2<=1;
       rd<=3;
    #1 Rd_dat<=32'd100;
    #1 wen<=1;
    #2 wen<=0;
    #100 $finish;
end

initial begin
        $dumpfile("regfile_tb.vcd");
        $dumpvars(0,RegFile_tb);
end
endmodule

