`timescale 1ns / 1ps

module uart_tx #(

    parameter CLK_FREQ_MHZ 	= 50,
	parameter CLK_UART_MHZ 	= CLK_FREQ_MHZ/50,
	parameter CLK_PERIOD_NS	= 1000/CLK_UART_MHZ,
	parameter WAIT_TIME_NS 	= 2000, //1sec
	parameter WAIT_TICKS 	= WAIT_TIME_NS / CLK_PERIOD_NS,
	parameter STR_LEN = 13

)
(
    input wire clk,
    input wire rst_n,
	output reg tx
);
 
 reg [STR_LEN*8-1:0] test_str = "Hello World!\n";
 
 wire mclk;
 reg clk_uart; 
 reg [7:0] data;
 reg [3:0] idx_byte;
 reg [3:0] idx_bit;
 reg [7:0] cnt;
 int wait_tick;
 
 /*state register*/
 enum reg [2:0] {
    WAIT_1SEC,
    GET_DATA,
    SEND_READY,
    SEND_DATA,
    SEND_STOP_DATA
}state, next_state;

/*clock */
always @(posedge mclk or negedge rst_n) begin
  if(~rst_n) begin
    cnt <= 0;
    clk_uart <= 0;
  end else begin
    if(cnt >= 50) begin
        cnt <= 0;
        clk_uart <= ~clk_uart;
    end
    else begin
        cnt <= cnt + 1;
    end
  end
end

assign mclk = clk;
/* mmcm */
/*
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
*/
/*state ©ø?¨ú?¡Æ¢®¡¾? sequence logic*/
always @(posedge clk_uart or negedge rst_n)begin

    if(~rst_n) state <= WAIT_1SEC;
    else
        state <= next_state;    
end
/*state combinational logic*/
always @(*) begin
    case(state)
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
                next_state = WAIT_1SEC;
            else
                next_state = GET_DATA;
         end
         
         default:
                next_state = WAIT_1SEC;
         
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
                 WAIT_1SEC: begin
                    data <= 0;
                    idx_bit <= 0;
                    idx_byte <= STR_LEN;                                    
                    wait_tick <= wait_tick + 1;
                    tx <= 1;
                 end
                 GET_DATA: begin
                     data <= test_str[idx_byte*8-1 -: 8];
                    
                 end
                 SEND_READY:begin
                     tx <= 0;
                     idx_bit <= 0;
                 
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
