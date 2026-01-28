module GPU (
    input wire[31:0] instructions[65535],
    input wire clock
);
    localparam int ProcessingBlocks = 8;
    localparam int A = 16;
    localparam int W = 32*16;

    reg[A-1:0] read_addr[ProcessingBlocks];
    reg[A-1:0] write_addr[ProcessingBlocks];
    reg[W-1:0] write_data[ProcessingBlocks];
    wire[W-1:0] read_out[ProcessingBlocks];
    wire load_ctrl[ProcessingBlocks];
    wire write_ctrl[ProcessingBlocks];

    main_memory #(
        .ADDR_WIDTH(A),
        .DATA_WIDTH(W),
        .MEM_CONTROLS(ProcessingBlocks)
    ) mem(read_addr, write_addr, write_data, write_ctrl, clock, read_out);

    genvar pb;
    generate
        for(pb=0; pb<8; pb=pb+1) begin : g_pbs
            processing_block p_block(
                .instructions(instructions),
                .load_data(read_out[pb]),
                .clock(clock),
                .load_addr(read_addr[pb]),
                .write_addr_main(write_addr[pb]),
                .write_data_main(write_data[pb]),
                .load_ctrl(load_ctrl[pb]),
                .write_ctrl(write_ctrl[pb])
            );
        end
    endgenerate
endmodule
