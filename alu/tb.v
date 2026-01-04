module tb;
    reg[7:0] a;
    reg[7:0] b;
    wire[7:0] y;
    reg[7:0] expected;
    reg clock;
    reg reset;
    reg is_output_valid;
    reg[3:0] alu_ctrl;

    alu al(a, b, alu_ctrl, clock, reset, y, is_output_valid);

    always #1 clock = ~clock;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        clock = 1'b1;
        reset = 1'b1;
        alu_ctrl = 4'b0001;

        //FP8 ADD
        a = 8'b01000000;
        b = 8'b01000000;
        expected = 8'b01001000;
        #1 reset = 1'b0;
        
        #10 assert(y === expected & is_output_valid) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);


        a = 8'b00101000;
        b = 8'b00010000;
        expected = 8'b00101001;

        #1 reset = 1'b1;
        #2 reset = 1'b0;

        #10 assert(y === expected & is_output_valid) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b01010000;
        b = 8'b00010000;
        expected = 8'b01010000;

        #1 reset = 1'b1;
        #2 reset = 1'b0;

        #10 assert(y === expected & is_output_valid) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b01010000;
        b = 8'b11010000;
        expected = 8'b00000000;

        #1 reset = 1'b1;
        #2 reset = 1'b0;

        #10 assert(y === expected & is_output_valid) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b01000001;
        b = 8'b11000000;
        expected = 8'b00101000;

        #1 reset = 1'b1;
        #2 reset = 1'b0;

        #10 assert(y === expected & is_output_valid) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b01001000;
        b = 8'b11010000;
        expected = 8'b11001000;

        #1 reset = 1'b1;
        #2 reset = 1'b0;

        #10 assert(y === expected & is_output_valid) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b11001000;
        b = 8'b11010000;
        expected = 8'b11010100;

        #1 reset = 1'b1;
        #2 reset = 1'b0;

        #10 assert(y === expected & is_output_valid) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        // FP8 MULTIPLY
        alu_ctrl = 4'b0010;

        a = 8'b01000000;
        b = 8'b01000000;
        expected = 8'b01001000;
        #1 reset = 1'b1;
        #1 reset = 1'b0;
        #10 assert(y === expected & is_output_valid) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b00111000;
        b = 8'b00111000;
        expected = 8'b00111000;
        #1 reset = 1'b1;
        #1 reset = 1'b0;
        #10 assert(y === expected & is_output_valid) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b00111000;
        b = 8'b10111000;
        expected = 8'b10111000;
        #1 reset = 1'b1;
        #1 reset = 1'b0;
        #10 assert(y === expected & is_output_valid) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b01000000;
        b = 8'b00111001;
        expected = 8'b01000001;
        #1 reset = 1'b1;
        #1 reset = 1'b0;
        #10 assert(y === expected & is_output_valid) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b10101100;
        b = 8'b11000000;
        expected = 8'b00110100;
        #1 reset = 1'b1;
        #1 reset = 1'b0;
        #10 assert(y === expected & is_output_valid) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b00000000;
        b = 8'b00000000;
        expected = 8'b00000000;
        #1 reset = 1'b1;
        #1 reset = 1'b0;
        #10 assert(y === expected & is_output_valid) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        
        $display("All test passed");
        $finish;
    end
endmodule

