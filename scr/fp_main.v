`include "fp_unpack.v"
`include "fp_align.v"
`include "fp_addsub.v"
`include "fp_normalize.v"
`include "fp_pack.v"
module fp_adder (
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] result
);
   // stage 1 unpack
    wire sign_a, sign_b;
    wire [7:0] exp_a, exp_b;
    wire [23:0] mant_a, mant_b;

    fp_unpack unpack_a (
        .in(a),
        .sign(sign_a),
        .exp(exp_a),
        .mant(mant_a)
    );
    fp_unpack unpack_b (
        .in(b),
        .sign(sign_b),
        .exp(exp_b),
        .mant(mant_b)
    );

    //  stage2 Align exponents
    wire [23:0] mant_a_shifted, mant_b_shifted;
    wire [7:0] exp_large;

    fp_align align_stage (
        .exp_a(exp_a),
        .exp_b(exp_b),
        .mant_a(mant_a),
        .mant_b(mant_b),
        .exp_large(exp_large),
        .mant_a_shift(mant_a_shifted),
        .mant_b_shift(mant_b_shifted)
    );

//stage 3 add/sub stage
wire [24:0] mant_sum;
wire sign_res;

fp_addsub addsub_stage (
    .mant_a_shift(mant_a_shifted),
    .mant_b_shift(mant_b_shifted),
    .sign_a(sign_a),
    .sign_b(sign_b),
    .mant_sum(mant_sum),
    .sign_res(sign_res)
);

    // --- Stage 4: Normalize ---
wire [23:0] mant_norm;
wire [7:0]  exp_norm;

fp_normalize normalize_stage (
    .mant_sum(mant_sum),
    .exp_in(exp_large),
    .exp_out(exp_norm),
    .mant_norm(mant_norm)
);

 // Stage 5: Pack
wire [31:0] fp_result;

fp_pack pack_stage (
    .mant_norm(mant_norm),
    .exp_norm(exp_norm),
    .sign_res(sign_res),
    .result(fp_result)
);

// Final output
assign result = fp_result;
endmodule
