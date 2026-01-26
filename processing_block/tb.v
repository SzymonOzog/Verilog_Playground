module tb;
    localparam W = 32*16-1;
    reg[31:0] instructions[65535];
    reg[W:0] load_data;
    reg clock;
    wire[15:0] load_addr;
    wire[15:0] write_addr;
    wire[W:0] write_data;
    wire load_ctrl;
    wire write_ctrl;

    processing_block pb(instructions,
        load_data, clock, load_addr,
        write_addr, write_data, load_ctrl, write_ctrl);

    always #1 clock = ~clock;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        // Load from main mem 0 to register 0
        instructions[0][31:24] = 8'b00100000;
        instructions[0][23:16] = 8'd0;
        instructions[0][15:0] = 16'd0;
        // Load from main mem 1 to register 1
        instructions[1][31:24] = 8'b00100000;
        instructions[1][23:16] = 8'd1;
        instructions[1][15:0] = 16'd1;
        // Load from main mem 2 to register 2
        instructions[2][31:24] = 8'b00100000;
        instructions[2][23:16] = 8'd2;
        instructions[2][15:0] = 16'd2;
        // Multiply register 0 * register 1 store in register 3
        instructions[2][31:24] = 8'b00000010;
        instructions[2][23:16] = 8'd3;
        instructions[2][15:8] = 8'd0;
        instructions[2][7:0] = 8'd1;
        // Add register 2 to register 3 store in register 4
        instructions[3][31:24] = 8'b00000001;
        instructions[3][23:16] = 8'd4;
        instructions[3][15:8] = 8'd3;
        instructions[3][7:0] = 8'd2;
        // Write register 4 to main mem
        instructions[4][31:24] = 8'b00010000;
        instructions[4][23:16] = 8'd4;
        instructions[4][15:0] = 16'd1;
        clock = 1'b1;

        #1 assert(load_addr === 16'd0) else $fatal(1, "wrong load addr expected %b, got %b", 
            16'd0, load_addr);

        $display("All test passed");
        $finish;
    end
endmodule


