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
// 1.第一次写入产生一个miss,然后从内存读取连续的64b.
// 2.第一次读取产生一个miss,然后再次读取连续64b内不再miss.
// 3.填满一个set(写入),然后再次写入一个不同地址产生一个replacement.
initial
begin
    rst_n=0;
    #2 rst_n=1;
//Test1:
    // #4 wr=1;
    // addr=32'h0000000c;
    // input_data=32'd100;

    // #4 mem_rd_data=32'd200;
    // #5 mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #4 mem_rd_data=32'd300;
    // mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #4 mem_rd_data=32'd400;
    // mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #4 mem_rd_data=32'd500;
    // mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #4 mem_rd_data=32'd600;
    // mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #4 mem_rd_data=32'd700;
    // mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #4 mem_rd_data=32'd800;
    // mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #4 mem_rd_data=32'd900;
    // mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #4 mem_rd_data=32'd1100;
    // mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #4 mem_rd_data=32'd1200;
    // mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #4 mem_rd_data=32'd1300;
    // mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #4 mem_rd_data=32'd1400;
    // mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #4 mem_rd_data=32'd1500;
    // mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #4 mem_rd_data=32'd1600;
    // mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #4 mem_rd_data=32'd2300;
    // mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #4 mem_rd_data=32'd11300;
    // mem_op_finish=1;
    // #2 mem_op_finish=0;

    // #16 wr=0;

    // //读出addr=32'h0000000c的数据

    // #4 rd=1;
    // addr=32'h0000000c;
    // #16 rd=0;

    // #4 rd=1;
    // addr=32'h00000010;
    // #16 rd=0;

    // #4 rd=1;
    // addr=32'h00000014;
    // #16 rd=0;

    // #4 rd=1;
    // addr=32'h0000002c;
    // #16 rd=0;

    // #4 rd=1;
    // addr=32'h0000003c;
    // #16 rd=0;

//Test2:
    // #4 rd=1;
    // addr=32'h00000104;//读取范围00000100~0000013c

    // #10  mem_op_finish=1;
    // mem_rd_data=32'd100;
    // #2 mem_op_finish=0;

    // #4 mem_op_finish=1;
    // mem_rd_data=32'd200;
    // #2 mem_op_finish=0;

    // #4 mem_op_finish=1;
    // mem_rd_data=32'd300;
    // #2 mem_op_finish=0;

    // #4 mem_op_finish=1;
    // mem_rd_data=32'd400;
    // #2 mem_op_finish=0;

    // #4 mem_op_finish=1;
    // mem_rd_data=32'd500;
    // #2 mem_op_finish=0;

    // #4 mem_op_finish=1;
    // mem_rd_data=32'd600;
    // #2 mem_op_finish=0;

    // #4 mem_op_finish=1;
    // mem_rd_data=32'd700;
    // #2 mem_op_finish=0;

    // #4 mem_op_finish=1;
    // mem_rd_data=32'd800;
    // #2 mem_op_finish=0;

    // #4 mem_op_finish=1;
    // mem_rd_data=32'd900;
    // #2 mem_op_finish=0;

    // #4 mem_op_finish=1;
    // mem_rd_data=32'd1000;
    // #2 mem_op_finish=0;

    // #4 mem_op_finish=1;
    // mem_rd_data=32'd1100;
    // #2 mem_op_finish=0;

    // #4 mem_op_finish=1;
    // mem_rd_data=32'd1200;
    // #2 mem_op_finish=0;

    // #4 mem_op_finish=1;
    // mem_rd_data=32'd1300;
    // #2 mem_op_finish=0;

    // #4 mem_op_finish=1;
    // mem_rd_data=32'd1400;
    // #2 mem_op_finish=0;

    // #4 mem_op_finish=1;
    // mem_rd_data=32'd1500;
    // #2 mem_op_finish=0;

    // #4 mem_op_finish=1;
    // mem_rd_data=32'd1600;
    // #2 mem_op_finish=0;
    // #16 rd=0;

    // #4 rd=1;
    // addr=32'h00000100;
    // #4 rd=0;

    // #4 rd=1;
    // addr=32'h00000104;
    // #4 rd=0;


    // #4 rd=1;
    // addr=32'h0000010c;
    // #4 rd=0;

//Test3
    //写入一个set:
    //slot1(00~3c)
    #4 wr=1;
    addr=32'h00001000;
    input_data=32'd100;

    #9 mem_op_finish=1;
    mem_rd_data=32'd10;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd20;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd30;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd40;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd50;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd60;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd70;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd80;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd90;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd100;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd110;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd120;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd130;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd140;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd150;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd160;
    #2 mem_op_finish=0;
    #16 wr=0;

    //slot2(40~7c)
    #4 wr=1;
    addr=32'h00002000;
    input_data=32'd2100;

    #9 mem_op_finish=1;
    mem_rd_data=32'd210;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd220;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd230;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd240;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd250;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd260;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd270;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd280;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd290;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd2100;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd2110;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd2120;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd2130;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd2140;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd2150;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd2160;
    #2 mem_op_finish=0;
    #16 wr=0;

    #4 wr=1;
    addr=32'h00003000;
    input_data=32'd30;
    #9 mem_op_finish=1;
    mem_rd_data=32'd3010;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd3020;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd3030;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd3040;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd3050;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd3060;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd3070;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd3080;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd3090;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd3100;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd3110;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd3120;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd3130;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd3140;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd3150;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd3160;
    #2 mem_op_finish=0;

    #16 wr=0;

    #4 wr=1;
    addr=32'h00004000;
    input_data=32'd40;
    #9 mem_op_finish=1;
    mem_rd_data=32'd4010;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd4020;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd4030;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd4040;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd4050;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd4060;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd4070;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd4080;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd4090;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd4100;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd4110;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd4120;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd4130;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd4140;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd4150;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd4160;
    #2 mem_op_finish=0;

    #16 wr=0;

    #4 wr=1;
    addr=32'h00005000;
    input_data=32'd50;
    #9 mem_op_finish=1;
    mem_rd_data=32'd5010;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd5020;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd5030;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd5040;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd5050;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd5060;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd5070;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd5080;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd5090;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd5100;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd5110;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd5120;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd5130;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd5140;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd5150;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd5160;
    #2 mem_op_finish=0;

    #16 wr=0;

    #4 wr=1;
    addr=32'h00006000;
    input_data=32'd60;
    #9 mem_op_finish=1;
    mem_rd_data=32'd6010;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd6020;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd6030;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd6040;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd6050;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd6060;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd6070;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd6080;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd6090;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd6100;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd6110;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd6120;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd6130;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd6140;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd6150;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd6160;
    #2 mem_op_finish=0;

    #16 wr=0;

    #4 wr=1;
    addr=32'h00007000;
    input_data=32'd70;
    #9 mem_op_finish=1;
    mem_rd_data=32'd7010;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd7020;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd7030;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd7040;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd7050;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd7060;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd7070;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd7080;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd7090;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd7100;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd7110;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd7120;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd7130;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd7140;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd7150;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd7160;
    #2 mem_op_finish=0;

    #16 wr=0;

    #4 wr=1;
    addr=32'h00008000;
    input_data=32'd80;
    #9 mem_op_finish=1;
    mem_rd_data=32'd8010;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd8020;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd8030;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd8040;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd8050;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd8060;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd8070;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd8080;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd8090;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd8100;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd8110;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd8120;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd8130;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd8140;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd8150;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd8160;
    #2 mem_op_finish=0;

    #16 wr=0;

    //再写入一次(9000) 产生replacement

    #4 wr=1;
    addr=32'h00009000;
    input_data=32'd1000;
    #9 mem_op_finish=1;
    mem_rd_data=32'd9010;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd9020;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd9030;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd9040;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd9050;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd9060;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd9070;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd9080;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd9090;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd9100;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd9110;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd9120;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd9130;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd9140;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd9150;
    #2 mem_op_finish=0;

    #6 mem_op_finish=1;
    mem_rd_data=32'd9160;
    #2 mem_op_finish=0;

// cache往mem写入一行数据
    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #4 mem_op_finish=1;
    #2 mem_op_finish=0;

    #16 wr=0;

    // //读取一个slot数据,每组读取三个way
    // //地址1000已被replacement.
    #4 rd=1;
    addr=32'h0000900c;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00009010;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00009014;
    #16 rd=0;

    #4 rd=1;
    addr=32'h0000200c;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00002010;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00002014;
    #16 rd=0;

    #4 rd=1;
    addr=32'h0000300c;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00003010;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00003014;
    #16 rd=0;

    #4 rd=1;
    addr=32'h0000400c;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00004010;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00004014;
    #16 rd=0;

    #4 rd=1;
    addr=32'h0000500c;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00005010;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00005014;
    #16 rd=0;

    #4 rd=1;
    addr=32'h0000600c;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00006010;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00006014;
    #16 rd=0;

    #4 rd=1;
    addr=32'h0000700c;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00007010;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00007014;
    #16 rd=0;

    #4 rd=1;
    addr=32'h0000800c;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00008010;
    #16 rd=0;
    #4 rd=1;
    addr=32'h00008014;
    #16 rd=0;

    #100 $finish;
end

initial begin
        $dumpfile("cache2_tb.vcd");
        $dumpvars(0,Cache2_tb);
end

endmodule

