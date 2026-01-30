module reg_file #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8
)(
    input wire [ADDR_WIDTH-1:0] r1_addr,
    input wire [ADDR_WIDTH-1:0] r2_addr,
    input wire [ADDR_WIDTH-1:0] write_addr,
    input wire [DATA_WIDTH-1:0] write_data,
    input wire write_ctrl,
    input wire clock,
    output wire [DATA_WIDTH-1:0] r1_out,
    output wire [DATA_WIDTH-1:0] r2_out
);

    localparam CAP = 1 << ADDR_WIDTH;

    reg [DATA_WIDTH-1:0] r1_out_reg;
    reg [DATA_WIDTH-1:0] r2_out_reg;
    reg [DATA_WIDTH-1:0] registers [CAP-1];

    assign r1_out = r1_out_reg;
    assign r2_out = r2_out_reg;

    always @(posedge clock) begin
        if (write_ctrl) begin
            registers[write_addr] = write_data;
        end
        r1_out_reg = registers[r1_addr];
        r2_out_reg = registers[r2_addr];
    end

endmodule
