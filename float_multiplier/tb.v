module tb;
    reg[7:0] a;
    reg[7:0] b;
    wire[7:0] y;
    reg[7:0] expected;
    reg clock;
    reg reset;
    reg is_output_valid;
    reg is_output_valid_bf16;

    float_multiplier_e4m3 multiplier(a, b, clock, reset, y, is_output_valid);

    reg[15:0] a_bf16;
    reg[15:0] b_bf16;
    wire[15:0] y_bf16;
    reg[15:0] expected_bf16;
    float_multiplier_bf16 multiplier_bf16(a_bf16, b_bf16, clock, reset, y_bf16, is_output_valid_bf16);

    always #1 clock = ~clock;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        clock = 1'b1;
        reset = 1'b1;

        a = 8'b01000000;
        b = 8'b01000000;
        expected = 8'b01001000;
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
        
        a_bf16 = 16'h3f80;
        b_bf16 = 16'hbf80;
        expected_bf16 = 16'hbf80;
        #1 reset = 1'b1;
        #1 reset = 1'b0;
        #10 assert(y_bf16 === expected_bf16 & is_output_valid_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);

        a_bf16 = 16'h0;
        b_bf16 = 16'h0;
        expected_bf16 = 16'h0;
        #1 reset = 1'b1;
        #1 reset = 1'b0;
        #10 assert(y_bf16 === expected_bf16 & is_output_valid_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);
        
        // TODO undestand why I need #1 after adding rounding here
        #1 a_bf16 = 16'hbf80;
        b_bf16 = 16'hbf80;
        expected_bf16 = 16'h3f80;
        #1 reset = 1'b1;
        #1 reset = 1'b0;
        #10 assert(y_bf16 === expected_bf16 & is_output_valid_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);

        a_bf16 = 16'hbf40;
        b_bf16 = 16'h3fe0;
        expected_bf16 = 16'hbfa8;
        #1 reset = 1'b1;
        #1 reset = 1'b0;
        #10 assert(y_bf16 === expected_bf16 & is_output_valid_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);

        // TODO understand rounding
        // a_bf16 = 16'h4348;
        // b_bf16 = 16'h3a83;
        // expected_bf16 = 16'h3e4d;
        // #1 reset = 1'b1;
        // #1 reset = 1'b0;
        // #10 assert(y_bf16 === expected_bf16 & is_output_valid_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b",
        //                                                  a_bf16, b_bf16, y_bf16, expected_bf16);

        $display("All test passed");
        $finish;
    end
endmodule

