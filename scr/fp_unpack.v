module fp_unpack(    input  [31:0] in,          // 32-bit IEEE754 float
                     output        sign,        // sign bit
                     output [7:0]  exp,         // exponent
                     output [23:0] mant         // mantissa with implicit 1
);
    assign sign = in[31];
    assign exp  = in[30:23];
    assign mant = (exp == 0) ? {1'b0, in[22:0]} : {1'b1, in[22:0]};
endmodule
