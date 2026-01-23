module processing_block(
    input wire[31:0] instructions[65535]
        );

    parameter CORES=32;
    parameter BITS=16;
    parameter W=(CORES*BITS-1);

    reg[15:0] instruction_ptr = 16'd0;
    wire[31:0] curr_instr = instructions[instruction_ptr];

    wire[3:0] alu_ctrl = curr_instr[27:24];
    wire[7:0] write_addr = curr_instr[23:16];
    wire[7:0] r1_addr = curr_instr[15:8];
    wire[7:0] r2_addr = curr_instr[7:0];

    reg[W:0] write_data;
    wire[W:0] r1;
    wire[W:0] r2;

    reg clock;
    reg write;

    reg_file #(
        .ADDR_WIDTH(8),
        .DATA_WIDTH(16*32)
    ) r_file(r1_addr, r2_addr, write_addr, write_data, write, clock, r1, r2);

    wire[W:0] alu_out;


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

    always @ (posedge clock) begin
        instruction_ptr = instruction_ptr + 1;
    end
endmodule
