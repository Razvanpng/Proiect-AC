module counter(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       enable,
    input  wire [7:0] period,
    input  wire [7:0] prescale,
    input  wire       upnotdown,
    input  wire       soft_reset,
    output reg  [7:0] value
);
    reg [7:0] pre_cnt;

    wire tick = (pre_cnt == prescale);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            value   <= 8'd0;
            pre_cnt <= 8'd0;
        end else if (soft_reset) begin
            value   <= 8'd0;
            pre_cnt <= 8'd0;
        end else if (enable) begin
            if (tick) begin
                pre_cnt <= 8'd0;

                if (upnotdown) begin
                    if (value >= period)
                        value <= 8'd0;
                    else
                        value <= value + 8'd1;
                end else begin
                    if (value == 8'd0)
                        value <= period;
                    else
                        value <= value - 8'd1;
                end
            end else begin
                pre_cnt <= pre_cnt + 8'd1;
            end
        end
    end

endmodule


