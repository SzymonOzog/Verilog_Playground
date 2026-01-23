module main_memory #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 16 
)(
    input wire [ADDR_WIDTH-1:0] read_addr,
    input wire [ADDR_WIDTH-1:0] write_addr,
    input wire [DATA_WIDTH-1:0] write_data,
    input wire write_ctrl,
    input wire clock,
    output wire [DATA_WIDTH-1:0] read_out
);
    localparam CAP = 1 << ADDR_WIDTH;

    reg [DATA_WIDTH-1:0] read_out_reg;
    reg [DATA_WIDTH-1:0] main_mem [0:CAP-1];

    assign read_out = read_out_reg;

    always @(posedge clock) begin
        if (write_ctrl) begin
            main_mem[write_addr] = write_data;
        end
        read_out_reg = main_mem[read_addr];
    end

endmodule
