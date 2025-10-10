module fp_align (
    input  [7:0]  exp_a,        // exponent of operand A
    input  [7:0]  exp_b,        // exponent of operand B
    input  [23:0] mant_a,       // mantissa of operand A (with implicit 1)
    input  [23:0] mant_b,       // mantissa of operand B (with implicit 1)
    output [7:0]  exp_large,    // larger exponent
    output [23:0] mant_a_shift, // shifted mantissa A
    output [23:0] mant_b_shift  // shifted mantissa B
);
    wire [7:0] exp_diff;
    assign exp_diff = (exp_a >= exp_b) ? (exp_a - exp_b) : (exp_b - exp_a);

    assign mant_a_shift = (exp_a >= exp_b) ? mant_a : (mant_a >> exp_diff);
    assign mant_b_shift = (exp_b >  exp_a) ?  mant_b: (mant_b >> exp_diff);
    assign exp_large    = (exp_a >= exp_b) ? exp_a : exp_b;
endmodule
