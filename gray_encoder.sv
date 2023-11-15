module gray_encoder(
    input [3:0] a,
    output reg [3:0] b

);

always@(*) begin
    for(int i = 3; i >= 0; i--)begin
        if (i == 3)
             b[i] = a[i];
        else
             b[i] = a[i+1] ^ a[i];
    end
end
    
endmodule