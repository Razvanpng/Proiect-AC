module instr_dcd(
    input  wire [7:0] cmd,
    output wire       is_write,
    output wire       is_valid,
    output wire [5:0] addr
);
    assign is_write = cmd[7];
    assign is_valid = cmd[6];
    assign addr     = cmd[5:0];
endmodule


