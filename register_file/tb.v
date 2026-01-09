module tb;
    reg[7:0] r1_addr;
    reg[7:0] r2_addr;

    reg[7:0] write_addr;
    reg[7:0] write_data;
    
    wire[7:0] r1_out;
    wire[7:0] r2_out;

    reg[7:0] expected1;
    reg[7:0] expected2;

    reg clock;
    reg write;

    reg_file r_file(r1_addr, r2_addr, write_addr, write_data, write, clock, r1_out, r2_out);

    always #1 clock = ~clock;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        clock = 1'b1;
        write = 1'b1;

        write_addr = 8'd10;
        write_data = 8'b01010101;

        r1_addr = write_addr;
        #2 write = 1'b0;

        #1 assert(r1_out === write_data) else $fatal(1, "wrong register read data, expected %b, got %b", 
            write_data, r1_out);


        #2 write_addr = 8'd11;
        write = 1'b1;
        write_data = 8'b00000101;

        r1_addr = write_addr;
        expected1 = write_data;

        #2 write_addr = 8'd15;
        write_data = 8'b11111111;

        r2_addr = write_addr;
        expected2 = write_data;

        #2 assert(r1_out === expected1) else $fatal(1, "wrong register read data, expected %b, got %b", 
            expected1, r1_out);
        assert(r2_out === expected2) else $fatal(1, "wrong register read data, expected %b, got %b", 
            expected2, r2_out);

        
        $display("All test passed");
        $finish;
    end
endmodule


