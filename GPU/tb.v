module tb;
    reg[31:0] instructions[65535];
    reg clock;

    always #1 clock = ~clock;

    GPU gpu(
        .instructions(instructions),
        .clock(clock),
        .launch_blocks(16'd16)
        );


    initial begin
        $dumpfile("dump.vcd");
        $readmemh("../axpy_vals.txt", gpu.mem.main_mem);
        $dumpvars(0, tb);

        // Mov 16(vec size) to reg 0
        instructions[0][31:24] = 8'b00110000;
        instructions[0][23:16] = 8'd0;
        instructions[0][15:0] = 16'd16;

        // Add 16 to BID (b address)
        instructions[1][31:24] = 8'b00000011;
        instructions[1][23:16] = 8'd1;
        instructions[1][15:8] = 8'd255;
        instructions[1][7:0] = 8'd0;

        // Add 16 to b address = c address
        instructions[2][31:24] = 8'b00000011;
        instructions[2][23:16] = 8'd2;
        instructions[2][15:8] = 8'd0;
        instructions[2][7:0] = 8'd1;

        // Add 16 to c address = out address
        instructions[3][31:24] = 8'b00000011;
        instructions[3][23:16] = 8'd3;
        instructions[3][15:8] = 8'd0;
        instructions[3][7:0] = 8'd2;

        // load a to memory at reg 4
        instructions[4][31:24] = 8'b00100000;
        instructions[4][23:16] = 8'd4;
        instructions[4][15:8] = 8'd255;

        // load b to memory at reg 5
        instructions[5][31:24] = 8'b00100000;
        instructions[5][23:16] = 8'd5;
        instructions[5][15:8] = 8'd1;

        // load c to memory at reg 6
        instructions[6][31:24] = 8'b00100000;
        instructions[6][23:16] = 8'd6;
        instructions[6][15:8] = 8'd2;

        // Multiply a*b store in register 7
        instructions[7][31:24] = 8'b00000010;
        instructions[7][23:16] = 8'd7;
        instructions[7][15:8] = 8'd4;
        instructions[7][7:0] = 8'd5;

        // Add c to (a*b) store in register 8
        instructions[8][31:24] = 8'b00000001;
        instructions[8][23:16] = 8'd8;
        instructions[8][15:8] = 8'd7;
        instructions[8][7:0] = 8'd6;

        // Write (a*b)+c to out
        instructions[9][31:24] = 8'b00010000;
        instructions[9][23:16] = 8'd8;
        instructions[9][7:0] = 8'd3;

        instructions[10] = 32'd0;
        clock = 1'b1;

        #200
        $writememh("../axpy_results.txt", gpu.mem.main_mem, 48, 63);
        $display("All test passed");
        $finish;
    end
endmodule
