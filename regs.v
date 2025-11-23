module regs (
    // peripheral clock signals
    input clk,
    input rst_n,
    // decoder facing signals
    input read,
    input write,
    input[5:0] addr,
    output[7:0] data_read,
    input[7:0] data_write,
    // counter programming signals
    input[15:0] counter_val,
    output[15:0] period,
    output en,
    output count_reset,
    output upnotdown,
    output[7:0] prescale,
    // PWM signal programming values
    output pwm_en,
    output[7:0] functions,
    output[15:0] compare1,
    output[15:0] compare2
);

// Register addresses
localparam PERIOD_LSB = 6'h00;
localparam PERIOD_MSB = 6'h01;
localparam COUNTER_EN = 6'h02;
localparam COMPARE1_LSB = 6'h03;
localparam COMPARE1_MSB = 6'h04;
localparam COMPARE2_LSB = 6'h05;
localparam COMPARE2_MSB = 6'h06;
localparam COUNTER_RESET = 6'h07;
localparam COUNTER_VAL_LSB = 6'h08;
localparam COUNTER_VAL_MSB = 6'h09;
localparam PRESCALE = 6'h0A;
localparam UPNOTDOWN = 6'h0B;
localparam PWM_EN = 6'h0C;
localparam FUNCTIONS = 6'h0D;

reg[15:0] period;
reg[15:0] compare1;
reg[15:0] compare2;
reg[7:0] prescale;
reg[7:0] functions;
reg en;
reg count_reset;
reg upnotdown;
reg pwm_en;
reg[7:0] data_read_reg;

assign data_read = data_read_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        period <= 16'h0000;
        compare1 <= 16'h0000;
        compare2 <= 16'h0000;
        prescale <= 8'h00;
        functions <= 8'h00;
        en <= 1'b0;
        count_reset <= 1'b0;
        upnotdown <= 1'b0;
        pwm_en <= 1'b0;
        data_read_reg <= 8'h00;
    end else begin
        // Clear count_reset after one cycle
        count_reset <= 1'b0;
        
        if (write) begin
            case (addr)
                PERIOD_LSB: period[7:0] <= data_write;
                PERIOD_MSB: period[15:8] <= data_write;
                COUNTER_EN: en <= data_write[0];
                COMPARE1_LSB: compare1[7:0] <= data_write;
                COMPARE1_MSB: compare1[15:8] <= data_write;
                COMPARE2_LSB: compare2[7:0] <= data_write;
                COMPARE2_MSB: compare2[15:8] <= data_write;
                COUNTER_RESET: count_reset <= 1'b1;
                PRESCALE: prescale <= data_write;
                UPNOTDOWN: upnotdown <= data_write[0];
                PWM_EN: pwm_en <= data_write[0];
                FUNCTIONS: functions <= data_write;
                default: ;
            endcase
        end
        
        if (read) begin
            case (addr)
                PERIOD_LSB: data_read_reg <= period[7:0];
                PERIOD_MSB: data_read_reg <= period[15:8];
                COUNTER_EN: data_read_reg <= {7'd0, en};
                COMPARE1_LSB: data_read_reg <= compare1[7:0];
                COMPARE1_MSB: data_read_reg <= compare1[15:8];
                COMPARE2_LSB: data_read_reg <= compare2[7:0];
                COMPARE2_MSB: data_read_reg <= compare2[15:8];
                COUNTER_VAL_LSB: data_read_reg <= counter_val[7:0];
                COUNTER_VAL_MSB: data_read_reg <= counter_val[15:8];
                PRESCALE: data_read_reg <= prescale;
                UPNOTDOWN: data_read_reg <= {7'd0, upnotdown};
                PWM_EN: data_read_reg <= {7'd0, pwm_en};
                FUNCTIONS: data_read_reg <= functions;
                default: data_read_reg <= 8'h00;
            endcase
        end
    end
end

endmodule

