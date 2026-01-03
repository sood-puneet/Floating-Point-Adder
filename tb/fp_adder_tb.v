`timescale 1ns/1ns
module tb_fp_adder;
    reg clk = 1'b0;
    reg [31:0] a, b;
    wire [31:0] result;

    fp_adder uut (
        .clk(clk),
        .a(a),
        .b(b),
        .result(result)
    );

    // 100MHz Clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Reset inputs
        a = 0; b = 0;
        
        // Wait
        @(posedge clk);
        #1; 
        //  1: 512 + 22.5
        a = 32'h44000000; b = 32'h41b40000; 
        @(posedge clk); #1;

        // 2: 233.3 + 212.2
        a = 32'h43695553; b = 32'h43543eb8; 
        @(posedge clk); #1;

        // 3: 456.4 + (-812.4)
        a = 32'h43e4370a; b = 32'hc44b1ccd; 
        @(posedge clk); #1;

        // Stop new inputs
        a = 0; b = 0;

        #50 $finish;
    end
endmodule
