module reg_file(
        input wire[7:0] r1_addr,
        input wire[7:0] r2_addr,
        input wire[7:0] write_addr,
        input wire[7:0] write_data,
        input wire write_ctrl,
        input wire clock,
        output wire[7:0] r1_out,
        output wire[7:0] r2_out
        );

        parameter CAP = 65536;

        reg[7:0] r1_out_next;
        reg[7:0] r2_out_next;

        reg[CAP][7:0] registers;

        assign r1_out = r1_out_next;
        assign r2_out = r2_out_next;

        always @ (posedge clock)
        begin
            if(write_ctrl)
            begin
                registers[write_addr] = write_data;
            end
            r1_out_next = registers[r1_addr];
            r2_out_next = registers[r2_addr];
        end

endmodule

module reg_file_16b(
        input wire[15:0] r1_addr,
        input wire[15:0] r2_addr,
        input wire[15:0] write_addr,
        input wire[15:0] write_data,
        input wire write_ctrl,
        input wire clock,
        output wire[15:0] r1_out,
        output wire[15:0] r2_out
        );

        parameter CAP = 65536;

        reg[15:0] r1_out_next;
        reg[15:0] r2_out_next;

        reg[CAP][15:0] registers;

        assign r1_out = r1_out_next;
        assign r2_out = r2_out_next;

        always @ (posedge clock)
        begin
            if(write_ctrl)
            begin
                registers[write_addr] = write_data;
            end
            r1_out_next = registers[r1_addr];
            r2_out_next = registers[r2_addr];
        end

endmodule
