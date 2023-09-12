module PLRU(input clk,
    input rst_n,
    input miss_happened,
    input hit_happened,
    input [2:0] hit_ptr,
    input [2:0] index,
    output reg [2:0] way_ptr=0
);
reg [63:0] slot_ptr;   // 8个set,8-way
integer i;
wire [5:0] ptr = {3'b0,index};
wire [7:0] pos = slot_ptr[ptr<<3+:8];
wire [5:0] hit_pos = {index,hit_ptr};
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        slot_ptr<=0;
    end
    else begin
        if(hit_happened) begin
            slot_ptr[hit_pos]<=1'b1;
            way_ptr<=hit_ptr;
        end
        else if(miss_happened) begin
            //set内全为1,那么重置为0.
            //返回最左边的0的index.
            if(pos==8'b11111111) begin
                slot_ptr[ptr<<3+:8]<=8'b10000000;
                way_ptr<=7;
            end
            else begin
                if(pos[7]==0) begin
                    way_ptr<=7;
                    slot_ptr[ptr<<3+:8]<= pos | 8'b10000000;
                end
                else if(pos[6]==0) begin
                    way_ptr<=6;
                    slot_ptr[ptr<<3+:8]<= pos | 8'b01000000;
                end
                else if(pos[5]==0) begin
                    way_ptr<=5;
                    slot_ptr[ptr<<3+:8]<= pos | 8'b00100000;
                end
                else if(pos[4]==0) begin
                    way_ptr<=4;
                    slot_ptr[ptr<<3+:8] <= pos | 8'b00010000;
                end
                else if(pos[3]==0) begin
                    way_ptr<=3;
                    slot_ptr[ptr<<3+:8] <= pos | 8'b00001000;
                end
                else if(pos[2]==0) begin
                    way_ptr<=2;
                    slot_ptr[ptr<<3+:8] <= pos | 8'b00000100;
                end
                else if(pos[1]==0) begin
                    way_ptr<=1;
                    slot_ptr[ptr<<3+:8] <= pos | 8'b00000010;
                end
                else if(pos[0]==0) begin
                    way_ptr<=0;
                    slot_ptr[ptr<<3+:8] <= pos | 8'b00000001;
                end
                else begin way_ptr<=0; end
            end
        end
        else begin
            way_ptr<=way_ptr;
        end
    end
end

endmodule
//set associate cache with plru policy
module Cache(
    input clk,
    input rst_n,
    input [31:0] addr,
    input rd,
    input wr,
    input [31:0] in_data,
    output reg[31:0] out_data=0,
    output reg   data_rdy=0,

    //Cache replacement
    input [31:0] rd_from_mem,
    output reg [31:0] mem_addr=0,
    output reg [31:0] wr_to_mem=0,
    output reg r_w=0,   //0->read 1->write.
    output reg enable=0,
    input mem_op_finish
);
localparam BLOCK_DATA_BYTE_SIZE  = 6;    // 数据部分长度
localparam DATA_OFFSET = 512;
localparam INDEX_BIT_SIZE  = 3;        // 索引部分长度
localparam SLOT_LENGTH     = 8;         // 槽个数.
localparam TAG_BIT_SIZE = 23;
localparam SLOT_OFFSET    = 32'd537;  //槽长度.一个槽包括ValidBit DirtyBit Tag DATA
// addr:
// |  TAG_BIT_SIZE(23bit)   |  INDEX_BIT_SIZE(3bit) |   BLOCK_DATA_BYTE_SIZE(6bit) |
//        TAG                        INDEX                        DATA
// slot结构:
//   MSB       MSB-1   |  TAG_BIT_SIZE   |    DATA_OFFSET(64b=64*8=512bit)   |
// Valid     DirtyBit        TAG                   DATA

reg [SLOT_OFFSET-1:0] _cache [0:(2<<INDEX_BIT_SIZE)-1] [0:SLOT_LENGTH-1];

integer i;
wire [INDEX_BIT_SIZE-1:0] decode_index = addr[INDEX_BIT_SIZE+BLOCK_DATA_BYTE_SIZE-1:BLOCK_DATA_BYTE_SIZE];
reg [(SLOT_LENGTH>>2):0] hit_ptr=0;
wire hit;

integer search2_i;

assign hit=((_cache[decode_index][0][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE])
    &&_cache[decode_index][0][SLOT_OFFSET-1]==1)
    ||((_cache[decode_index][1][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE])
    &&_cache[decode_index][1][SLOT_OFFSET-1]==1)
    ||((_cache[decode_index][2][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE])
    &&_cache[decode_index][2][SLOT_OFFSET-1]==1)
    ||((_cache[decode_index][3][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE])
    &&_cache[decode_index][3][SLOT_OFFSET-1]==1)
    ||((_cache[decode_index][4][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE])
    &&_cache[decode_index][4][SLOT_OFFSET-1]==1)
    ||((_cache[decode_index][5][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE])
    &&_cache[decode_index][5][SLOT_OFFSET-1]==1)
    ||((_cache[decode_index][6][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE])
    &&_cache[decode_index][6][SLOT_OFFSET-1]==1)
    ||((_cache[decode_index][7][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE])
    &&_cache[decode_index][7][SLOT_OFFSET-1]==1);

always@(*)
begin
    if(_cache[decode_index][0][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE]&&
    _cache[decode_index][0][SLOT_OFFSET-1]==1)
    begin
        hit_ptr<=0;
    end
    else if(_cache[decode_index][1][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE]&&
    _cache[decode_index][1][SLOT_OFFSET-1]==1) begin
        hit_ptr<=1;
    end
    else if(_cache[decode_index][2][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE]&&
    _cache[decode_index][2][SLOT_OFFSET-1]==1) begin
        hit_ptr<=2;
    end
    else if(_cache[decode_index][3][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE]&&
    _cache[decode_index][3][SLOT_OFFSET-1]==1) begin
        hit_ptr<=3;
    end
    else if(_cache[decode_index][4][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE]&&
    _cache[decode_index][4][SLOT_OFFSET-1]==1) begin
        hit_ptr<=4;
    end

    else if(_cache[decode_index][5][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE]&&
    _cache[decode_index][5][SLOT_OFFSET-1]==1) begin
        hit_ptr<=5;
    end
    else if(_cache[decode_index][6][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE]&&
    _cache[decode_index][6][SLOT_OFFSET-1]==1) begin
        hit_ptr<=6;
    end
    else if(_cache[decode_index][7][DATA_OFFSET+:TAG_BIT_SIZE]
    ==addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE]&&
    _cache[decode_index][7][SLOT_OFFSET-1]==1) begin
        hit_ptr<=7;
    end
    else hit_ptr<=0;
end

reg [1:0] rd_D;
reg [1:0] wr_D;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin rd_D<=0;  wr_D<=0; end
    else begin
        rd_D <= {rd_D[0],rd};
        wr_D <= {wr_D[0],wr};
    end
end
wire rd_start= ~rd_D[1] & rd_D[0];
wire wr_start= ~wr_D[1] & wr_D[0];

integer j;

// localparam CACHE_STATE_NORMAL=0;
localparam CACHE_STATE_MISS_READ_PREPARE=1;  //从Mem中读取需要的block
localparam CACHE_STATE_MISS_READ_WAIT=2;
localparam CACHE_STATE_MISS_READ_PROCESS=3;
localparam CACHE_STATE_CONFLICT_WB=4;
localparam CACHE_STATE_WRMISS_NOWR=5;
localparam CACHE_STATE_WRITE_BACK=6;  //将某一block写回Mem.
localparam CACHE_STATE_GET_SEL=7;
localparam CACHE_STATE_WR_PROCESS=8;
localparam CACHE_STATE_RD_PROCESS=9;

reg [3:0] cache_state=CACHE_STATE_GET_SEL;
reg [31:0] mem_recv_buf=0;
wire [7:0] data_addr = {4'b0,addr[3:0]};

wire [2:0] selected_way;
reg miss_s=0;
reg hit_s=0;
PLRU _inst_lru(
    clk,
    rst_n,
    miss_s,
    hit_s,
    hit_ptr,
    decode_index,
    selected_way
);
reg [0:0] counter=0;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0;i<(2<<INDEX_BIT_SIZE);i=i+1)
        begin
            for(j=0;j<SLOT_LENGTH;j=j+1)begin
                _cache[i][j]<=0;
            end
            data_rdy<=0;
        end
    end
    else begin
        case(cache_state)
            CACHE_STATE_GET_SEL:begin
                if(wr_start) begin
                        if(hit) begin
                            hit_s<=1;
                        end
                        else begin miss_s<=1; end
                        cache_state<=CACHE_STATE_WR_PROCESS;
                end
                else if(rd_start) begin
                        if(hit) begin
                            hit_s<=1;
                        end
                        else begin miss_s<=1; end
                        cache_state<=CACHE_STATE_RD_PROCESS;
                end
                else begin
                    hit_s<=0;
                    miss_s<=0;
                    cache_state<=CACHE_STATE_GET_SEL;
                    data_rdy<=0;
                    out_data<=out_data;
                end
            end   //STATE_GET_SEL

            CACHE_STATE_WR_PROCESS:begin
                // find tag. first,get the line by decode_index
                // if not find(miss), then get a empty slot,replacement(if need) and write.
                // else (hit)
                    // write and set dirty bit 1.
                if(counter==0)begin
                    hit_s<=0;
                    miss_s<=0;
                    counter<=counter+1;
                    cache_state<=CACHE_STATE_WR_PROCESS;
                end
                else if(counter==1)begin
                    counter<=0;
                    if(hit)begin
                        _cache[decode_index][hit_ptr][SLOT_OFFSET-1:SLOT_OFFSET-2]<={1'b1,1'b1};
                        _cache[decode_index][hit_ptr][DATA_OFFSET+:TAG_BIT_SIZE]<=addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE];
                        _cache[decode_index][hit_ptr][data_addr<<3+:32]<=in_data;
                        data_rdy<=1;
                        out_data<=out_data;
                        cache_state<=CACHE_STATE_GET_SEL;
                    end
                    else begin
                        out_data<=out_data;
                        data_rdy<=0;
                        if(_cache[decode_index][selected_way][SLOT_OFFSET-1]==0
                        ||_cache[decode_index][selected_way][SLOT_OFFSET-1:SLOT_OFFSET-2]==2'b10) begin
                            cache_state<=CACHE_STATE_WRMISS_NOWR;
                        end
                        else if(_cache[decode_index][selected_way][SLOT_OFFSET-1:SLOT_OFFSET-2]==2'b11) begin
                            cache_state<=CACHE_STATE_WRITE_BACK;
                        end
                    end
                end
            end  //STATE_WR_PROCESS

            CACHE_STATE_RD_PROCESS:begin
                // read.
                // find tag.(by decode_index)
                // not find, (read from mem ,(test:0xffff0000) set valid bit 1,dirty bit 0 )
                // then get an empty slot: replacement(if need) and write.
                // find:
                    // return data
                if(counter==0) begin
                    hit_s<=0;
                    miss_s<=0;
                    counter<=counter+1;
                    cache_state<=CACHE_STATE_RD_PROCESS;
                end
                else if(counter==1) begin
                    counter<=0;
                    if(hit) begin
                        out_data <= _cache[decode_index][hit_ptr][data_addr<<3+:32];
                        data_rdy<=1;
                        cache_state<=CACHE_STATE_GET_SEL;
                    end
                    else begin
                        enable<=1;
                        r_w<=0;
                        mem_addr<=addr;
                        cache_state<=CACHE_STATE_MISS_READ_WAIT;
                        data_rdy<=0;
                    end
                end

            end   //STATE_RD_PROCESS

            CACHE_STATE_MISS_READ_WAIT:
            begin
                if(mem_op_finish) begin
                    mem_recv_buf<=rd_from_mem;
                    enable<=0;
                    r_w<=0;
                    cache_state<=CACHE_STATE_MISS_READ_PROCESS;
                end
                else
                    cache_state<=CACHE_STATE_MISS_READ_WAIT;
            end  //CACHE_STATE_MISS_READ_WAIT
            CACHE_STATE_MISS_READ_PROCESS:begin
                out_data<=mem_recv_buf;

                if(_cache[decode_index][selected_way][SLOT_OFFSET-1:SLOT_OFFSET-2]==2'b11) begin
                    cache_state<=CACHE_STATE_CONFLICT_WB;
                    data_rdy<=0;
                end
                else begin
                    _cache[decode_index][selected_way][SLOT_OFFSET-1:SLOT_OFFSET-2]<={1'b1,1'b0};
                    _cache[decode_index][selected_way][DATA_OFFSET+:TAG_BIT_SIZE]<=addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE];
                    _cache[decode_index][selected_way][data_addr<<3+:32]<=mem_recv_buf;
                    data_rdy<=1;
                    cache_state<=CACHE_STATE_GET_SEL;
                end
            end
            CACHE_STATE_CONFLICT_WB:begin
                //写回 _cache[decode_index][slot_ptr[decode_index]]
                if(mem_op_finish) begin
                    enable<=0;
                    r_w<=0;
                    _cache[decode_index][selected_way][SLOT_OFFSET-1:SLOT_OFFSET-2]<={1'b1,1'b0};
                    _cache[decode_index][selected_way][DATA_OFFSET+:TAG_BIT_SIZE]<=addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE];
                    _cache[decode_index][selected_way][data_addr<<3+:32]<=mem_recv_buf;
                    data_rdy<=1;
                    cache_state<=CACHE_STATE_GET_SEL;
                end
                else begin
                    enable<=1;
                    r_w<=1;
                    data_rdy<=0;
                    wr_to_mem<=_cache[decode_index][selected_way][data_addr<<3+:32];
                    mem_addr<=addr;
                    cache_state<=CACHE_STATE_CONFLICT_WB;
                end
            end
            CACHE_STATE_WRMISS_NOWR: //如果miss,可能是第一次访问的compulsory miss(validBit=0)，不需要写回(replacement)，直接存储
            begin//或者写入发生conflict，但是被replacement的slot的dirtybit为0不需要被写回。
                enable<=0;
                r_w<=0;
                _cache[decode_index][selected_way][SLOT_OFFSET-1:SLOT_OFFSET-2]<={1'b1,1'b1};
                _cache[decode_index][selected_way][DATA_OFFSET+:TAG_BIT_SIZE]<=addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE];
                _cache[decode_index][selected_way][data_addr<<3+:32]<=in_data;
                data_rdy<=1;
                cache_state<=CACHE_STATE_GET_SEL;
            end
            CACHE_STATE_WRITE_BACK:
            //也可能是发生了conflict miss，判断dirtyBit是否需要写回，然后存储
            begin
                if(mem_op_finish) begin
                    enable<=0;
                    r_w<=0;
                    _cache[decode_index][selected_way][SLOT_OFFSET-1:SLOT_OFFSET-2]<={1'b1,1'b1};
                    _cache[decode_index][selected_way][DATA_OFFSET+:TAG_BIT_SIZE]<=addr[BLOCK_DATA_BYTE_SIZE+INDEX_BIT_SIZE+:TAG_BIT_SIZE];
                    _cache[decode_index][selected_way][data_addr<<3+:32]<=in_data;
                    data_rdy<=1;
                    cache_state<=CACHE_STATE_GET_SEL;
                end
                else begin
                    mem_addr<=addr;
                    data_rdy<=0;
                    wr_to_mem<=_cache[decode_index][selected_way][data_addr<<3+:32];
                    enable<=1;
                    r_w<=1;
                    cache_state<=CACHE_STATE_WRITE_BACK;
                end

            end
        endcase
    end
end

endmodule

