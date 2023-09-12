module Cache2_tb();
reg clk=0;
reg rd=0;
reg wr=0;
reg rst_n=1;
reg [31:0] input_data=0;
wire [31:0] output_data;
reg [31:0] addr=0;
wire data_rdy;
reg [31:0] mem_rd_data=0;
wire [31:0] mem_addr;
wire [31:0] wr_to_mem;
wire mem_rw;
wire mem_en;
reg mem_op_finish=0;
wire [53:0] test_cache_entry;
wire [2:0] test_slotptr;
Cache _inst_test_cache(
    clk,
    rst_n,
    addr,
    rd,
    wr,
    input_data,
    output_data,
    data_rdy,
    mem_rd_data,
    mem_addr,
    wr_to_mem,
    mem_rw,
    mem_en,
    mem_op_finish
);
always
#1 clk=~clk;

initial
begin
    rst_n=0;
    #2 rst_n=1;

    #4 wr=1;
    addr=32'h00000000;
    input_data=32'd100;   //miss
    #16 wr=0;

    #4 wr=1;
    addr=32'h00000004;
    input_data=32'd200;
    #16 wr=0;

    #4 wr=1;
    addr=32'h00000008;
    input_data=32'd300;
    #16 wr=0;

    #4 wr=1;
    addr=32'h0000000C;
    input_data=32'd400;
    #16 wr=0;

    #4 rd=1;
    addr=32'h00000000;
    #16 rd=0;

    #4 rd=1;
    addr=32'h00000004;
    #16 rd=0;


    #4 rd=1;
    addr=32'h00000008;
    #16 rd=0;


    #4 rd=1;
    addr=32'h0000000C;
    #16 rd=0;

    #4 wr=1;
    addr=32'b00000000000000000000000110_000000;
    input_data=32'd1700;    //miss
    #16 wr=0;

    #4 wr=1;
    addr=32'b00000000001100000000000110_000100;     //miss
    input_data=32'd2700;
    #16 wr=0;

    #4 wr=1;
    addr=32'b00001100000000000000000110_001000;     //miss
    input_data=32'd3700;
    #16 wr=0;
    #100 $finish;
end

initial begin
        $dumpfile("cache2_tb.vcd");
        $dumpvars(0,Cache2_tb);
end

endmodule

