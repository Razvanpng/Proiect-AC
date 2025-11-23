module counter (
    // peripheral clock signals
    input clk,
    input rst_n,
    // register facing signals
    output[15:0] count_val,
    input[15:0] period,
    input en,
    input count_reset,
    input upnotdown,
    input[7:0] prescale
);

reg[15:0] count_val_reg;
reg[7:0] prescale_counter;

assign count_val = count_val_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count_val_reg <= 16'd0;
        prescale_counter <= 8'd0;
    end else begin
        if (count_reset) begin
            count_val_reg <= 16'd0;
            prescale_counter <= 8'd0;
        end else if (en) begin
            if (prescale_counter >= prescale) begin
                prescale_counter <= 8'd0;
                
                if (upnotdown) begin
                    // Count up
                    if (count_val_reg >= period) begin
                        count_val_reg <= 16'd0;
                    end else begin
                        count_val_reg <= count_val_reg + 16'd1;
                    end
                end else begin
                    // Count down
                    if (count_val_reg == 16'd0) begin
                        count_val_reg <= period;
                    end else begin
                        count_val_reg <= count_val_reg - 16'd1;
                    end
                end
            end else begin
                prescale_counter <= prescale_counter + 8'd1;
            end
        end
    end
end

endmodule

