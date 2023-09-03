module DMem_Interface(
    input clk,
    input rst_n,
    input  wen,
    input  ren,
    input [31:0] wd,
    input [31:0] addr,
    output reg [31:0] rd_out=0,
    output reg dmem_rdy=0
);
reg [7:0] D_Cache [0:255];

always@(*)begin
    if(ren)begin
        rd_out<={D_Cache[addr],D_Cache[addr+1],D_Cache[addr+2],D_Cache[addr+3]};
        dmem_rdy<=1;
    end
    else begin
        rd_out<=rd_out;
        dmem_rdy<=0;
    end
end

integer i;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0;i<256;i++) D_Cache[i]<=0;
    end
    else if(wen)begin
        D_Cache[addr]  <=wd[24+:8];
        D_Cache[addr+1]<=wd[16+:8];
        D_Cache[addr+2]<=wd[8+:8];
        D_Cache[addr+3]<=wd[0+:8];
    end
end

endmodule
