module tb;
    reg[7:0] a;
    reg[7:0] b;
    wire[7:0] y;
    reg[7:0] expected;
    reg clock;
    reg[3:0] alu_ctrl;

    alu_e4m3 al(a, b, alu_ctrl, clock, y);

    reg[15:0] a_bf16;
    reg[15:0] b_bf16;
    wire[15:0] y_bf16;
    reg[15:0] expected_bf16;

    alu_bf16 alu_bf16(a_bf16, b_bf16, alu_ctrl, clock, y_bf16);

    always #1 clock = ~clock;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        clock = 1'b1;
        alu_ctrl = 4'b0001;

        //FP8 ADD
        a = 8'b01000000;
        b = 8'b01000000;
        expected = 8'b01001000;
        #10 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);


        a = 8'b00101000;
        b = 8'b00010000;
        expected = 8'b00101001;
        #10 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b01010000;
        b = 8'b00010000;
        expected = 8'b01010000;
        #10 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b01010000;
        b = 8'b11010000;
        expected = 8'b00000000;
        #10 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b01000001;
        b = 8'b11000000;
        expected = 8'b00101000;
        #10 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b01001000;
        b = 8'b11010000;
        expected = 8'b11001000;
        #10 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b11001000;
        b = 8'b11010000;
        expected = 8'b11010100;
        #10 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a_bf16 = 16'h3f80;
        b_bf16 = 16'hbf80;
        expected_bf16 = 16'h0;
        #10 assert(y_bf16 === expected_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);

        a_bf16 = 16'h0;
        b_bf16 = 16'h0;
        expected_bf16 = 16'h0;
        #10 assert(y_bf16 === expected_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);

        a_bf16 = 16'hbf80;
        b_bf16 = 16'hbf80;
        expected_bf16 = 16'hc000;
        #10 assert(y_bf16 === expected_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);

        a_bf16 = 16'hbf40;
        b_bf16 = 16'h3fe0;
        expected_bf16 = 16'h3f80;
        #10 assert(y_bf16 === expected_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);

        a_bf16 = 16'h4348;
        b_bf16 = 16'h3a83;
        expected_bf16 = 16'h4348;
        #10 assert(y_bf16 === expected_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);

        a_bf16 = 16'h3fff;
        b_bf16 = 16'h3fe0;
        expected_bf16 = 16'h4070;
        #10 assert(y_bf16 === expected_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);

        // FP8 MULTIPLY
        #1 alu_ctrl = 4'b0010;

        a = 8'b01000000;
        b = 8'b01000000;
        expected = 8'b01001000;
        #10 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b00111000;
        b = 8'b00111000;
        expected = 8'b00111000;
        #10 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b00111000;
        b = 8'b10111000;
        expected = 8'b10111000;
        #10 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b01000000;
        b = 8'b00111001;
        expected = 8'b01000001;
        #10 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b10101100;
        b = 8'b11000000;
        expected = 8'b00110100;
        #10 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b00000000;
        b = 8'b00000000;
        expected = 8'b00000000;
        #10 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);
        
        a_bf16 = 16'h3f80;
        b_bf16 = 16'hbf80;
        expected_bf16 = 16'hbf80;
        #10 assert(y_bf16 === expected_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);

        a_bf16 = 16'h0;
        b_bf16 = 16'h0;
        expected_bf16 = 16'h0;
        #10 assert(y_bf16 === expected_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);
        
        a_bf16 = 16'hbf80;
        b_bf16 = 16'hbf80;
        expected_bf16 = 16'h3f80;
        #10 assert(y_bf16 === expected_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);

        a_bf16 = 16'hbf40;
        b_bf16 = 16'h3fe0;
        expected_bf16 = 16'hbfa8;
        #10 assert(y_bf16 === expected_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);

        a_bf16 = 16'h4348;
        b_bf16 = 16'h3a83;
        expected_bf16 = 16'h3e4d;
        #10 assert(y_bf16 === expected_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);

        a_bf16 = 16'h3fff;
        b_bf16 = 16'h3fe0;
        expected_bf16 = 16'h405f;
        #10 assert(y_bf16 === expected_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);
        $display("All test passed");
        $finish;
    end
endmodule

