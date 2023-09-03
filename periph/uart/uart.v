module uart (
    input clk,
    input rx,
    output tx,
    input btn,   // tx enable
    output reg [5:0] led
);

parameter   DELAY_FRAME = 234;   // 115200
localparam  HALF_DELAY_WAIT =(DELAY_FRAME / 2);
localparam  RX_STATE_IDLE = 0;
localparam  RX_STATE_START_BIT = 1;
localparam  RX_STATE_READ_WAIT = 2;
localparam  RX_STATE_READ_BIT = 3;
localparam  RX_STATE_STOP = 4;

reg [3:0] rx_state = 0;
reg [12:0] rx_counter = 0;
reg [2:0] rx_bitNum = 0;
reg [7:0]  data_in = 0;
reg rx_rdy = 0;



always@(posedge clk) begin
    case(rx_state)
        RX_STATE_IDLE: begin
            if(rx==0) begin
                rx_state <= RX_STATE_START_BIT;
                rx_counter <= 1;
                rx_bitNum <= 0;
                rx_rdy <= 0;
            end
        end
        RX_STATE_START_BIT:begin
            if(rx_counter==HALF_DELAY_WAIT) begin
                //跳过start bit
                rx_state <= RX_STATE_READ_WAIT;
                rx_counter <= 1;
            end
            else
            begin
                rx_counter <= rx_counter + 1;
            end
        end
        RX_STATE_READ_WAIT:begin
            rx_counter <= rx_counter + 1;
            if(rx_counter + 1 == DELAY_FRAME) begin
                rx_state <= RX_STATE_READ_BIT;
            end
        end
        RX_STATE_READ_BIT:begin
            rx_counter <= 1;
            data_in <= {rx,data_in[7:1]};  //先接收到最低位.
            rx_bitNum <= rx_bitNum + 1;
            if(rx_bitNum == 3'b111)
                rx_state <= RX_STATE_STOP;
            else
                rx_state <= RX_STATE_READ_WAIT;
        end
        RX_STATE_STOP:begin
            rx_counter <= rx_counter + 1;
            if(rx_counter+1 == DELAY_FRAME)
            begin
                rx_rdy <= 1;
                rx_state <= RX_STATE_IDLE;
                rx_counter <= 0;
            end
        end
    endcase
end

always@(posedge clk)
begin
if(rx_rdy)  begin
    led <= ~data_in[5:0];
end
end

reg [3:0]  tx_state = 0;
reg [24:0] tx_counter= 0;
reg [7:0]  tx_out = 0;
reg [2:0]  tx_bitNum = 0;
reg [3:0]  tx_bytecounter = 0;
reg TC = 0;   //TX_Complete.
localparam TX_BUFF_SIZE = 5;
localparam TX_BUFF_LIMIT = 12;
reg [7:0] TX_BUFF[TX_BUFF_LIMIT-1:0];
reg tx_reg = 1;
assign tx = tx_reg;

initial begin
    TX_BUFF[0] = "H";
    TX_BUFF[1] = "e";
    TX_BUFF[2] = "l";
    TX_BUFF[3] = "l";
    TX_BUFF[4] = "o";
end

localparam TX_STATE_IDLE = 0;
localparam TX_STATE_START_BIT = 1;
localparam TX_STATE_WRITE = 2;
localparam TX_STATE_STOP = 3;

always@(posedge clk)
begin
    case(tx_state)
        TX_STATE_IDLE:
        begin
            if(btn==0)  begin
                tx_state <= TX_STATE_START_BIT;
                tx_counter <= 0;
                tx_bytecounter <= 0;
                tx_bitNum <= 0;

            end
            else
            begin
                tx_reg <= 1;

            end
            TC <= 0;
        end
        TX_STATE_START_BIT:
        begin
            tx_reg <= 0;    //tx start.
            if(tx_counter + 1 == DELAY_FRAME)
            begin
                tx_state <= TX_STATE_WRITE;
                tx_out <= TX_BUFF[tx_bytecounter];
                tx_bitNum <= 0;
                tx_counter <= 0;
            end
            else begin
                tx_counter <= tx_counter + 1;
                TC <= 0;
            end
        end
        TX_STATE_WRITE: begin
            tx_reg <= tx_out[tx_bitNum];
            if(tx_counter+1==DELAY_FRAME)
            begin
                    if(tx_bitNum==3'b111)
                    begin
                        tx_bitNum <= 0;
                        tx_state <= TX_STATE_STOP;
                    end
                    else
                    begin
                            tx_bitNum <= tx_bitNum + 1;
                            tx_state <= TX_STATE_WRITE;
                    end
                    tx_counter <= 0;
            end
            else
            begin
                    tx_counter <= tx_counter + 1;
                    TC <= 0;
            end
        end
        TX_STATE_STOP:  begin
            tx_reg <= 1;
            TC <= 1;
            if(tx_counter+1==DELAY_FRAME)
            begin
                    if(tx_bytecounter== TX_BUFF_SIZE-1)
                        tx_state <= TX_STATE_IDLE;
                    else begin
                        tx_bytecounter <= tx_bytecounter + 1;
                        tx_state <= TX_STATE_START_BIT;
                    end
                    tx_counter <= 0;
            end
            else
                tx_counter <= tx_counter + 1;
        end
    endcase
end


endmodule
