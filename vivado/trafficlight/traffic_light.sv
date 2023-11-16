`timescale 1ns / 1ps


module traffic_light();

    localparam S_RST = 4'b1000;
    localparam S0 = 4'b0000;
    localparam S1 = 4'b0001;
    localparam S2 = 4'b0010;
    localparam S3 = 4'b0011;
    localparam S4 = 4'b0100;
    localparam S5 = 4'b0101;
    localparam S6 = 4'b0110;
    localparam S7 = 4'b0111;

   reg rst_n;
   reg clk;
   reg [3:0] state, next_state;

   reg nscar_g, nscar_r, nscar_y, nscar_l;
   reg ewcar_g, ewcar_r, ewcar_y, ewcar_l;

   reg [7:0] timer;

   initial begin
      clk = 0;

      state = S_RST;

      // 내부 타이머
      timer = 1;

      // 신호등 led 출력
      nscar_g = 1; 
      nscar_y = 0;
      nscar_r = 0;
      nscar_l = 0;
      ewcar_g = 0;
      ewcar_y = 0;
      ewcar_r = 1;
      ewcar_l = 0;

      rst_n = 1;
      #30
      rst_n = 0;
      #30
      rst_n = 1;
   end

   always begin
      #5
      clk = ~clk;
   end



    // Clocked Present State Logic
   always @ (posedge clk or negedge rst_n) begin
      if (~rst_n) state <= S_RST;
      else      state <= next_state;
   end

   // Next State Logic
   always @ (*) begin
      case(state)
         S_RST: next_state = S0;
         S0: begin
            if (timer  == 40)    
               next_state = S1;
            else
               next_state = state;
         end
         S1: begin 
            if (timer  == 5)    
               next_state = S2;
            else
               next_state = state;
         end
         S2: begin
            if (timer  == 20)    
               next_state = S3;
            else
               next_state = state;
         end
         S3: begin
            if (timer  == 5)    
               next_state = S4;
            else
               next_state = state;
         end
         S4: begin
            if (timer  == 40)    
               next_state = S5;
            else
               next_state = state;
         end
         S5: begin
            if (timer  == 5)    
               next_state = S6;
            else
               next_state = state;
         end
         S6: begin
            if (timer  == 20)    
               next_state = S7;
            else
               next_state = state;
         end
         S7: begin
            if (timer  == 5)    
               next_state = S0;
            else
               next_state = state;
         end
      endcase
   end

    // Output Combinatorial Logic
    always @ (posedge clk or negedge rst_n) begin

       if (~rst_n) begin
         nscar_g <= 1; 
         nscar_y <= 0;
         nscar_r <= 0;
         nscar_l <= 0;
         ewcar_g <= 0;
         ewcar_y <= 0;
         ewcar_r <= 1;
         ewcar_l <= 0;
         timer <= 1;
       end
       else begin
          case(state) 
            S_RST: begin
                nscar_g <= 1; 
                nscar_y <= 0;
                nscar_r <= 0;
                nscar_l <= 0;
                ewcar_g <= 0;
                ewcar_y <= 0;
                ewcar_r <= 1;
                ewcar_l <= 0;
                timer <= 1;
            end 

            S0: begin
                nscar_g <= 1; 
                nscar_y <= 0;
                nscar_r <= 0;
                nscar_l <= 0;
                ewcar_g <= 0;
                ewcar_y <= 0;
                ewcar_r <= 1;
                ewcar_l <= 0;
                timer <= 1;
                
               if (timer < 40)
                  timer <= timer +1;
               else
                  timer <= 1;
            end 

            S1: begin
                nscar_g <= 0; 
                nscar_y <= 1;
                nscar_r <= 0;
                nscar_l <= 0;
                ewcar_g <= 0;
                ewcar_y <= 0;
                ewcar_r <= 1;
                ewcar_l <= 0;
                timer <= 1;

               if (timer < 5)
                  timer <= timer +1;
               else
                  timer <= 1;
            end 

            S2: begin
                nscar_g <= 0; 
                nscar_y <= 0;
                nscar_r <= 1;
                nscar_l <= 0;
                ewcar_g <= 0;
                ewcar_y <= 0;
                ewcar_r <= 0;
                ewcar_l <= 1;
                timer <= 1;

               if (timer < 20)
                  timer <= timer +1;
               else
                  timer <= 1;
            end 
             S3: begin
                nscar_g <= 0; 
                nscar_y <= 0;
                nscar_r <= 1;
                nscar_l <= 0;
                ewcar_g <= 0;
                ewcar_y <= 1;
                ewcar_r <= 0;
                ewcar_l <= 0;
                timer <= 1;

               if (timer < 5)
                  timer <= timer +1;
               else
                  timer <= 1;
            end 
             S4: begin
                nscar_g <= 0; 
                nscar_y <= 0;
                nscar_r <= 1;
                nscar_l <= 0;
                ewcar_g <= 1;
                ewcar_y <= 0;
                ewcar_r <= 0;
                ewcar_l <= 0;
                timer <= 1;

               if (timer < 40)
                  timer <= timer +1;
               else
                  timer <= 1;
            end 
             S5: begin
                nscar_g <= 0; 
                nscar_y <= 0;
                nscar_r <= 1;
                nscar_l <= 0;
                ewcar_g <= 0;
                ewcar_y <= 1;
                ewcar_r <= 0;
                ewcar_l <= 0;
                timer <= 1;

               if (timer < 5)
                  timer <= timer +1;
               else
                  timer <= 1;
            end 
             S6: begin
                nscar_g <= 0; 
                nscar_y <= 0;
                nscar_r <= 0;
                nscar_l <= 1;
                ewcar_g <= 0;
                ewcar_y <= 0;
                ewcar_r <= 1;
                ewcar_l <= 0;
                timer <= 1;

               if (timer < 20)
                  timer <= timer +1;
               else
                  timer <= 1;
            end 
             S7: begin
                nscar_g <= 0; 
                nscar_y <= 1;
                nscar_r <= 0;
                nscar_l <= 0;
                ewcar_g <= 0;
                ewcar_y <= 0;
                ewcar_r <= 1;
                ewcar_l <= 0;
                timer <= 1;

               if (timer < 5)
                  timer <= timer +1;
               else
                  timer <= 1;
            end 
         endcase
       end


    end



endmodule
