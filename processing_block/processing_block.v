module processing_block(
        );
    reg[15:0] r1_addr;
    reg[15:0] r2_addr;

    reg[15:0] write_addr;
    reg[15:0] write_data;
    
    wire[15:0] r1;
    wire[15:0] r2;

    reg clock;
    reg write;

    reg_file_16b r_file(r1_addr, r2_addr, write_addr, write_data, write, clock, r1, r2);

    wire[15:0] alu_out;
    reg reset;
    reg is_output_valid;
    reg[3:0] alu_ctrl;

    alu_bf16 al(r1, r2, alu_ctrl, clock, reset, alu_out, is_output_valid);

endmodule
