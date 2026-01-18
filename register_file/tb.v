module tb;

    reg[7:0] r1_addr;
    reg[7:0] r2_addr;
    reg[7:0] write_addr;
    reg[7:0] write_data;
    wire[7:0] r1_out;
    wire[7:0] r2_out;
    reg[7:0] expected1;
    reg[7:0] expected2;

    reg[15:0] r1_addr_16;
    reg[15:0] r2_addr_16;
    reg[15:0] write_addr_16;
    reg[15:0] write_data_16;
    wire[15:0] r1_out_16;
    wire[15:0] r2_out_16;
    reg[15:0] expected1_16;
    reg[15:0] expected2_16;

    reg clock;
    reg write;

    reg_file r_file(r1_addr, r2_addr, write_addr, write_data, write, clock, r1_out, r2_out);
    reg_file_16b r_file_16(r1_addr_16, r2_addr_16, write_addr_16, write_data_16, write, clock, r1_out_16, r2_out_16);

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

        write_addr_16 = 16'hF00D; 
        write_data_16 = 16'hABCD;
        r1_addr_16 = write_addr_16;

        #2 assert(r1_out_16 === write_data_16) else 
            $fatal(1, "16-bit: wrong read data, expected %h, got %h", write_data_16, r1_out_16);

        write_addr_16 = 16'h1111;
        write_data_16 = 16'h1234;
        r1_addr_16 = write_addr_16;
        expected1_16 = write_data_16;

        #2 write_addr_16 = 16'hFFFF;
        write_data_16 = 16'h5678;
        r2_addr_16 = write_addr_16;
        expected2_16 = write_data_16;

        #2 assert(r1_out_16 === expected1_16) else $fatal(1, "wrong register read data, expected %b, got %b", 
            expected1_16, r1_out_16);
        assert(r2_out_16 === expected2_16) else $fatal(1, "wrong register read data, expected %b, got %b", 
            expected2_16, r2_out_16);
        
        
        $display("All test passed");
        $finish;
    end
endmodule


