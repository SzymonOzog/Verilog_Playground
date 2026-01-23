module tb;
    reg[7:0] read_addr;
    reg[7:0] write_addr;
    reg[7:0] write_data;
    wire[7:0] read_out;
    reg[7:0] expected;

    reg clock;
    reg write;

    main_memory #(
        .ADDR_WIDTH(8),
        .DATA_WIDTH(8)
    ) main_mem(read_addr, write_addr, write_data, write, clock, read_out);

    always #1 clock = ~clock;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        clock = 1'b1;
        write = 1'b1;

        write_addr = 8'd10;
        write_data = 8'b01010101;

        read_addr = write_addr;
        #2 write = 1'b0;

        #1 assert(read_out === write_data) else $fatal(1, "wrong main memory read data, expected %b, got %b", 
            write_data, read_out);


        #2 write_addr = 8'd11;
        write = 1'b1;
        write_data = 8'b00000101;

        read_addr = write_addr;
        expected = write_data;

        #2 write_addr = 8'd15;
        write_data = 8'b11111111;

        #2 assert(read_out === expected) else $fatal(1, "wrong main_memory read data, expected %b, got %b", 
            expected, read_out);
        
        $display("All test passed");
        $finish;
    end
endmodule


