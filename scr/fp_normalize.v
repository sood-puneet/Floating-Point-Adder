module fp_normalize (
    input  [24:0] mant_sum,    // raw mantissa (25 bits from add/sub)
    input  [7:0]  exp_in,      // larger exponent from alignment
    output reg [23:0] mant_norm, // normalized mantissa (24 bits)
    output reg [7:0]  exp_out   // adjusted exponent
);
    integer i;
    reg [4:0] lz_count;     // first  one counter (0–24)
    reg found_one;

    always @(*) begin
        exp_out  = exp_in;
        mant_norm = 0;
        found_one = 0;
        lz_count  = 0;

        // Case 1: Overflow (carry out)
        if (mant_sum[24]) begin
           if (exp_in >= 8'd254) begin 
        //  254 + 1 = 255 (Infinity)
        exp_out   = 8'hFF;
        else begin
        // Normal carry handling
        mant_norm = mant_sum[24:1];
        exp_out   = exp_in + 1'b1;
    end
    end
        end 
        else begin
            // Case 2: No overflow, may need to normalize left
            for (i = 23; i >= 0; i = i - 1) begin
                if (!found_one && mant_sum[i]) begin
                    lz_count  = 23 - i;
                    found_one = 1;
                end
            end

            // Prevent exponent underflow
            if (exp_in > lz_count)
                exp_out = exp_in - lz_count;
            else
                exp_out = 0;
            // Shift mantissa left by leading zero count
            mant_norm = mant_sum[23:0] << lz_count;
        end
    end
endmodule
