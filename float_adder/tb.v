module tb;
    reg[7:0] a;
    reg[7:0] b;
    wire[7:0] y;
    reg[7:0] expected;
    reg clock;

    float_adder_e4m3 adder(a, b, clock, y);

    reg[15:0] a_bf16;
    reg[15:0] b_bf16;
    wire[15:0] y_bf16;
    reg[15:0] expected_bf16;
    float_adder_bf16 adder_bf16(a_bf16, b_bf16, clock, y_bf16);

    always #1 clock = ~clock;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        clock = 1'b1;

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

        //TODO: Should we care about this
        // a_bf16 = 16'h0000;
        // b_bf16 = 16'h8000;
        // expected_bf16 = 16'h8000;
        // #10 assert(y_bf16 === expected_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
        //                                                  a_bf16, b_bf16, y_bf16, expected_bf16);

        //TODO: This should pass
        // a_bf16 = 16'h0000;
        // b_bf16 = 16'hC033;
        // expected_bf16 = 16'hC033;
        // #10 assert(y_bf16 === expected_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
        //                                                  a_bf16, b_bf16, y_bf16, expected_bf16);
        $display("All test passed");
        $finish;
    end
endmodule

