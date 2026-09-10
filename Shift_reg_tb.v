module Shift_reg_tb ();
    reg clk;
	reg rst_n;
	reg valid_in;
	reg [15: 0 ] Data_in;
    wire [127:0] Data_out;


Shift_Reg #(.depth(8), .width(16)) DUT(
    .clk(clk),
	.rst_n(rst_n),
	.valid_in(valid_in),
	.Data_in(Data_in),
    .Data_out(Data_out) 
);	

always #5 clk = ~clk;
initial begin 
clk  = 1'b0;
rst_n = 1'b1;
valid_in = 1'b0;
Data_in = 'b0;
@(posedge clk);
rst_n = 1'b0;

repeat(2) @(posedge clk);
rst_n = 1'b1;
valid_in = 1'b1;
$display("time is %0t , Data out is: %b", $time , Data_out);
@(posedge clk)
Data_in = 16'b1111_1111_1111_1111;
$display("time is %0t , Data out is: %b", $time , Data_out);
@(posedge clk)
Data_in = 16'b1010_1010_1010_0101;
$display("time is %0t , Data out is: %b", $time , Data_out);
@(posedge clk)
Data_in = 16'b1001_1001_1001_1001;
$display("time is %0t , Data out is: %b", $time , Data_out);
@(posedge clk)
Data_in = 16'b1110_1110_1110_1110;
$display("time is %0t , Data out is: %b", $time , Data_out);
@(posedge clk)
Data_in = 16'b1110_0111_0111_0111;
$display("time is %0t , Data out is: %b", $time , Data_out);
@(posedge clk)
rst_n = 1'b0;
Data_in = 16'b1111_1111_1111_1111;
$display("time is %0t , Data out is: %b", $time , Data_out);

@(posedge clk);
rst_n = 1'b1;
$display("time is %0t , Data out is: %b", $time , Data_out);
@(posedge clk);

$finish;
end
endmodule
