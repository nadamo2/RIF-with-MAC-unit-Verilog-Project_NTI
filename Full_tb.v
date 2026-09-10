module Full_tb();
    reg clk;
	reg rst_n;
	reg valid_in;
	reg [15 : 0 ] Data_in;
    wire [34 : 0] Data_Mac_Out;

reg [15:0] memory [0:39];
reg [34 : 0] expected [0:39];
Top_Module #(.depth(8), .width(16)) DUT(
    .clk(clk),
	.rst_n(rst_n),
	.valid_in(valid_in),
	.Data_in(Data_in),
    .Data_Mac_Out(Data_Mac_Out)
);

always #5 clk = ~clk;

initial begin 
$readmemh("input_samples.hex", memory);
$readmemh("expected_output.hex", expected);
end

initial begin 
init();
reset();
send_data();
$finish;
end


task init;
begin 
clk = 1'b0;
rst_n = 1'b1;
valid_in = 1'b0;
Data_in = 'b1;
end
endtask

task reset; 
begin 
@(negedge clk);
rst_n = 1'b0;
repeat(2) @(negedge clk);
rst_n = 1'b1;
end
endtask

task send_data;
integer i;
begin 
for(i = 0; i<40; i = i+1) begin 
Data_in = memory[i];
valid_in = 1'b1;
@(negedge clk);
if (i >= 8) begin
        if (expected[i-8] == Data_Mac_Out) 
            $display("Done: i=%0d, expected=%b, got=%b", i, expected[i-8], Data_Mac_Out);
        else 
            $display("ERROR: i=%0d, expected=%b, got=%b", i, expected[i-8], Data_Mac_Out);
    end
end
end
endtask
endmodule