module instr_dcd (
    // peripheral clock signals
    input clk,
    input rst_n,
    // towards SPI slave interface signals
    input byte_sync,
    input[7:0] data_in,
    output[7:0] data_out,
    // register access signals
    output read,
    output write,
    output[5:0] addr,
    input[7:0] data_read,
    output[7:0] data_write
);

reg state;
reg[7:0] instruction_byte;
reg read_reg;
reg write_reg;
reg[5:0] addr_reg;
reg[7:0] data_write_reg;
reg[7:0] data_out_reg;

localparam WAIT_INSTRUCTION = 1'b0;
localparam WAIT_DATA = 1'b1;

assign read = read_reg;
assign write = write_reg;
assign addr = addr_reg;
assign data_write = data_write_reg;
assign data_out = data_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= WAIT_INSTRUCTION;
        instruction_byte <= 8'd0;
        read_reg <= 1'b0;
        write_reg <= 1'b0;
        addr_reg <= 6'd0;
        data_write_reg <= 8'd0;
        data_out_reg <= 8'd0;
    end else begin
        read_reg <= 1'b0;
        write_reg <= 1'b0;
        
        if (byte_sync) begin
            if (state == WAIT_INSTRUCTION) begin
                // First byte - instruction
                instruction_byte <= data_in;
                state <= WAIT_DATA;
            end else begin
                // Second byte - data
                addr_reg <= instruction_byte[5:0];
                data_write_reg <= data_in;
                
                if (instruction_byte[7]) begin
                    // Write operation
                    write_reg <= 1'b1;
                    data_out_reg <= 8'h00;
                end else begin
                    // Read operation
                    read_reg <= 1'b1;
                    data_out_reg <= data_read;
                end
                
                state <= WAIT_INSTRUCTION;
            end
        end
    end
end

endmodule


