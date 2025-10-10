module fp_addsub (
    input  [23:0] mant_a_shift,   // aligned mantissa of A
    input  [23:0] mant_b_shift,   // aligned mantissa of B
    input         sign_a,         // sign of A
    input         sign_b,         // sign of B
    output reg [24:0] mant_sum,   // raw mantissa result (25 bits for carry)
    output reg        sign_res    // result sign
);
    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign  add mantissas
            mant_sum = mant_a_shift + mant_b_shift;
            sign_res = sign_a;
        end 
        else begin
            // Different signs subtract smaller from larger
            if (mant_a_shift >= mant_b_shift) begin
                mant_sum = mant_a_shift - mant_b_shift;
                sign_res = sign_a;
            end 
            else begin
                mant_sum = mant_b_shift - mant_a_shift;
                sign_res = sign_b;
            end
        end
    end
endmodule
