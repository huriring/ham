module gray_decoder(

    input [3:0] b,
    output reg [3:0] a

);

always@(*) begin
    for(int i = 3; i >= 0; i--)begin
        if (i == 3)
             a[i] = b[i];
        else
             a[i] = a[i+1] ^ b[i];
    end
end

endmodule
