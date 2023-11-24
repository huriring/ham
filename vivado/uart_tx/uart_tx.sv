`timescale 1ns / 1ps

module uart_tx #(

    parameter CLK_FREQ_MHZ 	= 50,
	parameter CLK_UART_MHZ 	= CLK_FREQ_MHZ/50,
	parameter CLK_PERIOD_NS	= 1000/CLK_UART_MHZ,
	parameter WAIT_TIME_NS 	= 10**9, //1sec
	parameter WAIT_TICKS 	= WAIT_TIME_NS / CLK_PERIOD_NS,
	parameter STR_LEN = 14

 )
 (
    input wire clk,
	output reg tx
 );
 
 reg [STR_LEN*8-1:0] test_str = "Hello World!\n";
 
 wire mclk;
 reg clk_uart;
 wire rst_n;
 
 reg [7:0] data;
 reg [3:0] idx_byte;
 reg [3:0] idx_bit;
 int wait_tick;
 
 /*state register*/
 enum reg [2:0] {
    READY,
    WAIT_1SEC,
    GET_DATA,
    SEND_READY,
    SEND_DATA,
    SEND_STOP_DATA
}state, next_state;

/*clock */
always @(posedge mclk) begin
    static int cnt;
    if(cnt >= 50) begin
        cnt <= 0;
        clk_uart <= ~clk_uart;
    end
    else begin
        cnt <= cnt + 1;
    end
end
/* mmcm */
mmcm mmcm_50 (
    .reset(1'b0),
    .clk_in1(clk),
    .clk_out1(mclk)
);
ila_0 ila(
	 .clk		(mclk)
	,.probe0 	(clk_uart)
	,.probe1 	(tx)
	,.probe2 	(data)
	,.probe3 	(locked)
	,.probe4 	(idx_byte)
	,.probe5 	(idx_bit)
	,.probe6 	(state)
	,.probe7 	(next_state)
);

vio_0 vio(
    .clk (mclk),
    .probe_out0 (rst_n)
);
/*state 넘어가기 sequence logic*/
always @(posedge clk_uart or negedge rst_n)begin

    if(~rst_n) state <= READY;
    else
        state <= next_state;    
end
/*state combinational logic*/
always @(*) begin
    case(state)
        READY: begin
            next_state = WAIT_1SEC;
        end
        WAIT_1SEC: begin
            if(wait_tick >= WAIT_TICKS)
                next_state = GET_DATA;

        end
        GET_DATA : begin
            next_state = SEND_READY;
        end
        SEND_READY : begin
            next_state = SEND_DATA;
        end
        SEND_DATA : begin
            if(idx_bit == 8)
                next_state = SEND_STOP_DATA;

         end
         SEND_STOP_DATA: begin
            if(idx_byte == 0)
                next_state = READY;
            else
                next_state = GET_DATA;
         end
         
         default:
                next_state = READY;
         
    endcase
end

always @(posedge clk_uart or negedge rst_n) begin
        if(~rst_n) begin
                data <= 0;
                idx_bit <=0;
                idx_byte <= 0;
                wait_tick <= 0;
                tx <= 1;
       end
       else begin
            case (next_state)
                READY: begin
                    data <= 0;
                    idx_bit <= 0;
                    idx_byte <= STR_LEN;
                    wait_tick <= 0;
                    tx <= 1;
                 end
                 WAIT_1SEC: begin
                    wait_tick <= wait_tick + 1;
                 end
                 GET_DATA: begin
                     data <= test_str[idx_byte*8-1 -: 8];
                 end
                 SEND_READY:begin
                     tx <= 0;
                 end
                 SEND_DATA: begin
                    tx <= data[idx_bit];
                    idx_bit <= idx_bit + 1;
                 end
                 SEND_STOP_DATA: begin
                    tx <= 1;
                    idx_byte <= idx_byte - 1;
                 end
            endcase
       end
 end

endmodule
