module fp_pack (
    input  [23:0] mant_norm,   // normalized mantissa 
    input  [7:0]  exp_norm,    // adjusted exponent
    input         sign_res,    // result sign
    output [31:0] result       // final IEEE-754 32-bit output
);
    reg [31:0] temp_result;

    always @(*) begin
        // Handle special cases
        if (exp_norm == 8'd0) begin
            // Underflow zero
            temp_result = {sign_res, 8'd0, 23'd0};
        end 
        else if (exp_norm == 8'hFF) begin
            // Overflow infinity
            temp_result = {sign_res, 8'hFF, 23'd0};
        end 
        else begin
            // Normal case pack
            temp_result = {sign_res, exp_norm, mant_norm[22:0]};
        end
    end

    assign result = temp_result;
endmodule
