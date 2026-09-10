module Top_Module #(parameter depth = 8, width = 16)(
    input wire clk,
	input wire rst_n,
	input wire valid_in,
	input wire [width - 1 : 0 ] Data_in,
    output wire [34 : 0] Data_Mac_Out  
);
wire [(depth * width) - 1 : 0] floating_data;
Shift_Reg #(.depth(depth), .width(width)) DUT_REG(
    .clk(clk),
	.rst_n(rst_n),
	.valid_in(valid_in),
	.Data_in(Data_in),
    .Data_out(floating_data)
);

MAC_unit #(.depth(depth), .width(width)) DUT_MAC(
    .Data_Mac_in(floating_data),
    .clk(clk),
    .rst_n(rst_n),
    .valid_count(valid_in),
    .Data_Mac_Out(Data_Mac_Out)
);

endmodule