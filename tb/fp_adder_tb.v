`timescale 1ns/1ns

module tb_fp_adder;

    reg  [31:0] a, b;
    wire [31:0] result;
    fp_adder uut (
        .a(a),
        .b(b),
        .result(result)
    );

    task show;
        input [31:0] a_in;
        input [31:0] b_in;
        input [31:0] res_in;
        begin
            $display("time=%0t | a=%h | b=%h | result=%h", 
                      $time, a_in, b_in, res_in);
        end
    endtask

    initial begin
        $dumpfile("fp_adder_tb.vcd");   //for waveform dump
        $dumpvars(0, tb_fp_adder);

        a = 32'h44000000;  //512
        b = 32'h41b40000;   // 22.5
        #10 show(a, b, result);
        
        a = 32'h00000000; //0
        b = 32'h00000000; //0
        #10 show(a, b, result);

         a = 32'h43695553;  //233.3333
         b = 32'h43543eb8;  //212.245  
        #10 show(a, b, result);

         a = 32'h43e4370a;  //456.43
         b = 32'hc44b1ccd;  //- 812.45
        #10 show(a, b, result);

         a = 32'h44fe43d7;  //2034.12
         b = 32'hc4fa0000;  //-2000
        #10 show(a, b, result);


       #5 $finish;
    end

endmodule
