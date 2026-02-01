module GPU (
    input wire[31:0] instructions[65535],
    input wire clock,
    input wire[15:0] launch_blocks
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
    reg[15:0] curr_block_idx[ProcessingBlocks];

    wire[7:0] block_finished;
    reg kernel_finished = 1'b0;
    reg reset = 1'b0;

    wire mem_clock = ~clock;
    main_memory #(
        .ADDR_WIDTH(A),
        .DATA_WIDTH(W),
        .MEM_CONTROLS(ProcessingBlocks)
    ) mem(read_addr, write_addr, write_data, write_ctrl, mem_clock, read_out);

    int i;
    initial begin
        for (i=0; i<ProcessingBlocks; i=i+1) begin
            curr_block_idx[i] = i[15:0];
        end
    end


    genvar pb;
    generate
        for(pb=0; pb<8; pb=pb+1) begin : g_pbs
            processing_block p_block(
                .instructions(instructions),
                .block_idx(curr_block_idx[pb]),
                .load_data(read_out[pb]),
                .clock(clock),
                .reset(reset),
                .load_addr(read_addr[pb]),
                .write_addr_main(write_addr[pb]),
                .write_data_main(write_data[pb]),
                .load_ctrl(load_ctrl[pb]),
                .write_ctrl(write_ctrl[pb]),
                .finished(block_finished[pb])
            );
        end
    endgenerate

    always @(posedge clock) begin
        if(block_finished == 8'hFF & !kernel_finished) begin
            for (i=0; i<ProcessingBlocks; i=i+1) begin
                curr_block_idx[i] = curr_block_idx[i] + ProcessingBlocks;
                if(curr_block_idx[i] == (launch_blocks-1)) begin
                    kernel_finished = 1'b1;
                end
            end
            reset = 1'b1;
        end
    end

    always @(negedge clock) begin
        if (reset) begin
            reset = 1'b0;
        end
    end
endmodule
