module fp_align (
    input  [7:0]  exp_a,        // exponent of operand A
    input  [7:0]  exp_b,        // exponent of operand B
    input  [23:0] mant_a,       // mantissa of operand A (with implicit 1)
    input  [23:0] mant_b,       // mantissa of operand B (with implicit 1)
    output [7:0]  exp_large,    // larger exponent
    output [23:0] mant_a_shift, // shifted mantissa A
    output [23:0] mant_b_shift  // shifted mantissa B
);
    wire a_larger = (exp_a >= exp_b);
    wire [7:0] exp_diff;
    assign exp_diff = (a_larger) ? (exp_a - exp_b) : (exp_b - exp_a);
    assign mant_a_shift = (a_larger) ? mant_a : (mant_a >> exp_diff);
    assign mant_b_shift = (a_larger) ?  (mant_b >> exp_diff) :  mant_b;
    assign exp_large    = (a_larger) ? exp_a : exp_b;
endmodule
