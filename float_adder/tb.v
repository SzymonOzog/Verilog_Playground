module tb;
    reg[7:0] a;
    reg[7:0] b;
    wire[7:0] y;
    reg[7:0] expected;

    float_adder_e4m3 adder(a, b, y);


    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        a = 8'b01000000;
        b = 8'b01000000;
        expected = 8'b01001000;
        
        #1 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b00101000;
        b = 8'b00010000;
        expected = 8'b00101001;
        
        #1 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);

        a = 8'b01010000;
        b = 8'b00010000;
        expected = 8'b01010000;
        
        #1 assert(y === expected) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, expected);


        $display("All test passed");
        $finish;
    end
endmodule

