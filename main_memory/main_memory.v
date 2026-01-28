module main_memory #(
    parameter int ADDR_WIDTH = 16,
    parameter int DATA_WIDTH = 16,
    parameter int MEM_CONTROLS = 8
)(
    input wire [ADDR_WIDTH-1:0] read_addr[MEM_CONTROLS],
    input wire [ADDR_WIDTH-1:0] write_addr[MEM_CONTROLS],
    input wire [DATA_WIDTH-1:0] write_data[MEM_CONTROLS],
    input wire write_ctrl[MEM_CONTROLS],
    input wire clock,
    output wire [DATA_WIDTH-1:0] read_out[MEM_CONTROLS]
);
    localparam int CAP = 1 << ADDR_WIDTH;

    reg [DATA_WIDTH-1:0] main_mem [CAP-1];
    reg [DATA_WIDTH-1:0] read_out_reg[MEM_CONTROLS];
    assign read_out = read_out_reg;

    int i;

    always_ff @(posedge clock) begin
        for (i=0; i<MEM_CONTROLS; i++) begin
            if (write_ctrl[i]) begin
                main_mem[write_addr[i]] <= write_data[i];
            end
            read_out_reg[i] <= main_mem[read_addr[i]];
        end
    end
endmodule
