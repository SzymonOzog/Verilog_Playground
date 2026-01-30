module processing_block #(
    parameter int CORES=32,
    parameter int BITS=16,
    localparam int W=(CORES*BITS-1)
)(
    input wire[31:0] instructions[65535],
    input wire[W:0] load_data,
    input wire clock,
    input wire reset,
    output wire[15:0] load_addr,
    output wire[15:0] write_addr_main,
    output wire[W:0] write_data_main,
    output wire load_ctrl,
    output wire write_ctrl,
    output wire finished
        );

    reg[15:0] instruction_ptr = 16'd0;
    reg[31:0] curr_instr;

    wire[3:0] instr_op = curr_instr[31:28];
    wire[3:0] alu_ctrl = curr_instr[27:24];

    wire alu_op = instr_op == 4'd0;
    wire write_op = instr_op == 4'd1;
    wire load_op = instr_op == 4'd2;
    wire mov_op = instr_op == 4'd3;

    wire[7:0] write_addr_reg = curr_instr[23:16];
    wire[7:0] r1_addr = write_op ? curr_instr[23:16] : curr_instr[15:8];
    wire[7:0] r2_addr = curr_instr[7:0];

    wire[W:0] r1;
    wire[W:0] r2;
    wire[W:0] alu_out;
    wire write_reg = alu_op | load_op | mov_op;

    assign load_addr = r1[15:0];
    assign write_addr_main = r2[15:0];
    assign write_data_main = r1;
    assign load_ctrl = load_op;
    assign write_ctrl = write_op;

    wire[W:0] write_data_reg = load_op ? load_data :
                               alu_op  ? alu_out :
                               mov_op  ? {32{curr_instr[15:0]}} : 0;

    reg_file #(
        .ADDR_WIDTH(8),
        .DATA_WIDTH(BITS*CORES)
    ) r_file(r1_addr, r2_addr, write_addr_reg, write_data_reg, write_reg, clock, r1, r2);
    reg pipeline_stage;

    assign finished = (curr_instr == 32'd0);

    genvar i;
    generate
        for(i=0; i<CORES; i=i+1) begin : g_alus
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
        if (reset) begin
            instruction_ptr = 16'd0;
            pipeline_stage = 1'b0;
        end
        curr_instr = instructions[instruction_ptr];
    end

    always @ (negedge clock) begin
        if (pipeline_stage & !finished)
        begin
            instruction_ptr = instruction_ptr + 1;
            pipeline_stage = 1'b0;
        end
        else
        begin
            pipeline_stage = 1'b1;
        end
        curr_instr = instructions[instruction_ptr];
    end
endmodule
