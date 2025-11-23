module pwm_gen (
    // peripheral clock signals
    input clk,
    input rst_n,
    // PWM signal register configuration
    input pwm_en,
    input[15:0] period,
    input[7:0] functions,
    input[15:0] compare1,
    input[15:0] compare2,
    input[15:0] count_val,
    // top facing signals
    output pwm_out
);

reg pwm_out_reg;

assign pwm_out = pwm_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pwm_out_reg <= 1'b0;
    end else begin
        if (!pwm_en) begin
            pwm_out_reg <= 1'b0;
        end else begin
            case (functions[1:0])
                2'b00: begin
                    // Left-aligned PWM (align = 0)
                    if (count_val < compare1) begin
                        pwm_out_reg <= 1'b1;
                    end else begin
                        pwm_out_reg <= 1'b0;
                    end
                end
                
                2'b01: begin
                    // Right-aligned PWM (align = 1)
                    if (count_val >= (period - compare1)) begin
                        pwm_out_reg <= 1'b1;
                    end else begin
                        pwm_out_reg <= 1'b0;
                    end
                end
                
                default: pwm_out_reg <= 1'b0;
            endcase
        end
    end
end

endmodule
