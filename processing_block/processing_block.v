module processing_block(
        );

    parameter CORES=32;
    parameter BITS=16;
    parameter W=(CORES*BITS-1);

    reg[7:0] r1_addr;
    reg[7:0] r2_addr;

    reg[7:0] write_addr;
    reg[W:0] write_data;
    
    wire[W:0] r1;
    wire[W:0] r2;

    reg clock;
    reg write;

    reg_file #(
        .ADDR_WIDTH(8),
        .DATA_WIDTH(16*32)
    )_file(r1_addr, r2_addr, write_addr, write_data, write, clock, r1, r2);

    wire[W:0] alu_out;

    reg[3:0] alu_ctrl;

    genvar i;
    generate
        for(i=0; i<CORES; i=i+1) begin : alus
            alu_bf16 alu_inst (
                .a(r1[i*BITS +: BITS]),
                .b(r2[i*BITS +: BITS]),
                .alu_ctrl(alu_ctrl),
                .clock(clock),
                .y(alu_out[i*BITS +: BITS])
            );
        end
    endgenerate
endmodule
