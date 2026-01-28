module tb;
    localparam int MemControls=2;
    reg[7:0] read_addr[MemControls];
    reg[7:0] write_addr[MemControls];
    reg[7:0] write_data[MemControls];
    wire[7:0] read_out[MemControls];
    reg[7:0] expected[MemControls];

    reg clock;
    reg write[MemControls];

    main_memory #(
        .ADDR_WIDTH(8),
        .DATA_WIDTH(8),
        .MEM_CONTROLS(MemControls)
    ) main_mem(read_addr, write_addr, write_data, write, clock, read_out);

    always #1 clock = ~clock;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        clock = 1'b1;
        write[0] = 1'b1;
        write[1] = 1'b0;

        write_addr[0] = 8'd10;
        write_data[0] = 8'b01010101;

        read_addr[1] = write_addr[0];
        #2 write[0] = 1'b0;

        #1 assert(read_out[1] === write_data[0]) else $fatal(1, "wrong data, expected %b, got %b",
            write_data[0], read_out[1]);


        #2 write_addr[1] = 8'd11;
        write[1] = 1'b1;
        write_data[1] = 8'b00000101;

        read_addr[0] = write_addr[1];
        expected[0] = write_data[1];

        #2 write_addr[0] = 8'd15;
        write_data[0] = 8'b11111111;

        #2 assert(read_out[0] === expected[0]) else $fatal(1, "wrong data, expected %b, got %b",
            expected[0], read_out[0]);
        $display("All test passed");
        $finish;
    end
endmodule


