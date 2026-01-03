`include "fp_align.v"
`include "fp_pack.v"
`include "fp_addsub.v"
`include "fp_normalize.v"
`include "fp_unpack.v"

module fp_adder (
    input clk,
    input  [31:0] a,
    input  [31:0] b,
    output reg [31:0] result
);
   //  unpack
    wire sign_a, sign_b;
    wire [7:0] exp_a, exp_b;
    wire [23:0] mant_a, mant_b;

    fp_unpack unpack_a(
        .in(a),
        .sign(sign_a),
        .exp(exp_a),
        .mant(mant_a)
    );
    fp_unpack unpack_b(
        .in(b),
        .sign(sign_b),
        .exp(exp_b),
        .mant(mant_b)
    );

    //Align exponents
    wire [23:0] mant_a_shifted, mant_b_shifted;
    wire [7:0] exp_large;

    fp_align align_stage(
        .exp_a(exp_a),
        .exp_b(exp_b),
        .mant_a(mant_a),
        .mant_b(mant_b),
        .exp_large(exp_large),
        .mant_a_shift(mant_a_shifted),
        .mant_b_shift(mant_b_shifted)
    );

// pipeline stage 1 storage
reg [23:0] pipe1_mant_a, pipe1_mant_b;
reg [7:0]  pipe1_exp_large;
reg  pipe1_sign_a, pipe1_sign_b;

always @(posedge clk) begin
    pipe1_mant_a    <= mant_a_shifted;
    pipe1_mant_b    <= mant_b_shifted;
    pipe1_exp_large <= exp_large;
    pipe1_sign_a    <= sign_a;
    pipe1_sign_b    <= sign_b;
end

//add/sub stage
wire [24:0] mant_sum;
wire sign_res;

fp_addsub addsub_stage(
    .mant_a_shift(pipe1_mant_a), 
    .mant_b_shift(pipe1_mant_b), 
    .sign_a(pipe1_sign_a),       
    .sign_b(pipe1_sign_b),       
    .mant_sum(mant_sum),
    .sign_res(sign_res)
);
//stage 2 pipeline
reg [24:0] pipe2_mant_sum;
reg pipe2_sign_res;
reg [7:0]  pipe2_exp_large;

always @(posedge clk) begin
    pipe2_mant_sum  <= mant_sum;       // From Add/Sub
    pipe2_sign_res  <= sign_res;       // From Add/Sub
    pipe2_exp_large <= pipe1_exp_large; // Passed forward from Stage 1
end

    // Normalize ---
wire [23:0] mant_norm;
wire [7:0]  exp_norm;

fp_normalize normalize_stage(
    .mant_sum(pipe2_mant_sum),
    .exp_in(pipe2_exp_large),
    .exp_out(exp_norm),
    .mant_norm(mant_norm)
);

 //  Pack
wire [31:0] fp_result;

fp_pack pack_stage(
    .mant_norm(mant_norm),
    .exp_norm(exp_norm),
    .sign_res(pipe2_sign_res),
    .result(fp_result)
);

always @(posedge clk) begin
    result <= fp_result; 
end
endmodule
