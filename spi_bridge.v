module spi_bridge (
    // peripheral clock signals
    input clk,
    input rst_n,
    // SPI master facing signals
    input sclk,
    input cs_n,
    input mosi,
    output miso,
    // internal facing 
    output byte_sync,
    output[7:0] data_in,
    input[7:0] data_out
);

reg[7:0] shift_reg_in;
reg[7:0] shift_reg_out;
reg[2:0] bit_counter;
reg byte_sync_reg;
reg miso_reg;

assign miso = miso_reg;
assign byte_sync = byte_sync_reg;
assign data_in = shift_reg_in;

always @(posedge sclk or posedge cs_n) begin
    if (cs_n) begin
        bit_counter <= 3'd0;
        byte_sync_reg <= 1'b0;
        shift_reg_out <= data_out;
        shift_reg_in <= 8'd0;
        miso_reg <= 1'b0;
    end else begin
        // Shift in from MOSI
        shift_reg_in <= {shift_reg_in[6:0], mosi};
        
        // Shift out to MISO
        miso_reg <= shift_reg_out[7];
        shift_reg_out <= {shift_reg_out[6:0], 1'b0};
        
        // Count bits
        bit_counter <= bit_counter + 3'd1;
        
        // Generate byte_sync pulse after 8 bits
        if (bit_counter == 3'd7) begin
            byte_sync_reg <= 1'b1;
        end else begin
            byte_sync_reg <= 1'b0;
        end
    end
end

endmodule
