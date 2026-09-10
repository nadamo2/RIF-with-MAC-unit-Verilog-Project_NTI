module Shift_Reg #(parameter depth = 8, width = 16)(
    input wire clk,
	input wire rst_n,
	input wire valid_in,
	input wire [width - 1 : 0 ] Data_in,
    output wire [(width * depth) - 1:0] Data_out 
);

integer i;
reg [width - 1:0] virtual_reg [0 : depth - 1];
always @(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin  
	for (i = 0; i< depth; i = i +1) begin 
	    virtual_reg[i] <= 'b0; 
	end
	end else if(valid_in) begin 
	virtual_reg[0] <= Data_in;
	virtual_reg[1] <= virtual_reg[0];
	virtual_reg[2] <= virtual_reg[1];
	virtual_reg[3] <= virtual_reg[2];
	virtual_reg[4] <= virtual_reg[3];
	virtual_reg[5] <= virtual_reg[4];
	virtual_reg[6] <= virtual_reg[5];
	virtual_reg[7] <= virtual_reg[6];
	end 
end

assign Data_out = {virtual_reg[7], virtual_reg[6], virtual_reg[5], virtual_reg[4], virtual_reg[3], virtual_reg[2], virtual_reg[1], virtual_reg[0]};

endmodule
