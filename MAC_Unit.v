module MAC_unit #(parameter depth = 8, width = 16)(
    input wire [(depth * width) - 1 : 0] Data_Mac_in,
    input wire clk,
    input wire rst_n,
    input wire valid_count,
    output reg [34 : 0] Data_Mac_Out    
);

parameter  [width-1:0] H0 = 16'sd117;
parameter  [width-1:0] H1 = 16'sd1248;
parameter  [width-1:0] H2 = 16'sd5277;
parameter  [width-1:0] H3 = 16'sd9743;
parameter  [width-1:0] H4 = 16'sd9743;
parameter  [width-1:0] H5 = 16'sd5277;
parameter  [width-1:0] H6 = 16'sd1248;
parameter  [width-1:0] H7 = 16'sd117;

wire signed [width - 1 : 0 ] coeffs [0 : depth -1];
assign coeffs[0] = H0;
assign coeffs[1] = H1;
assign coeffs[2] = H2;
assign coeffs[3] = H3;
assign coeffs[4] = H4;
assign coeffs[5] = H5;
assign coeffs[6] = H6;
assign coeffs[7] = H7;

reg [3 : 0] counter;
wire [(width * 2) - 1 : 0] data_multi [0 : depth - 1];
genvar i;
generate 
    for(i = 0 ; i<depth ; i = i+ 1) begin 
        assign data_multi [i] = coeffs[i] * Data_Mac_in[width*i +: width];
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin 
    counter <= 'b0;
    Data_Mac_Out <= 'b0;
    end else if (counter >= 4'b1000) begin 
    Data_Mac_Out <= data_multi[0] + data_multi[1] + data_multi[2] + data_multi[3] + data_multi[4] + data_multi[5] + data_multi[6] + data_multi[7]; 
    end else if(valid_count) begin 
    counter <= counter +1;
    end

end
endmodule
