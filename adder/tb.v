
module tb;
    reg[7:0] a;
    reg[7:0] b;
    reg carry_in;
    wire[7:0] y;
    wire[7:0] y2;
    wire carry;
    wire carry2;

    adder8 adder(a, b, carry_in, y, carry);
    ripple_adder8 ripple_adder(a, b, carry_in, y2, carry2);


    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        a = 8'd5;
        b = 8'd5;
        carry_in = 0;
        
        #1 assert(y === 8'd10 & carry === 1'b0) else $fatal(1, "wrong output for a %b b %b y=%b", a, b, y);
        #1 assert(y2 === 8'd10 & carry2 === 1'b0) else $fatal(1, "wrong ripple output for a %b b %b y=%b", a, b, y2);

        a = 8'd8;
        b = 8'd5;
        carry_in = 0;
        
        #1 assert(y === 8'd13 & carry === 1'b0) else $fatal(1, "wrong output for a %b b %b y=%b", a, b, y);
        #1 assert(y2 === 8'd13 & carry2 === 1'b0) else $fatal(1, "wrong ripple output for a %b b %b y=%b", a, b, y2);

        a = 8'd8;
        b = 8'd5;
        carry_in = 1;
        
        #1 assert(y === 8'd3 & carry === 1'b1) else $fatal(1, "wrong output for a %b b %b y=%b", a, b, y);
        #1 assert(y2 === 8'd3 & carry2 === 1'b1) else $fatal(1, "wrong ripple output for a %b b %b y=%b, %b", a, b, y2, y);

        a = 8'd5;
        b = 8'd8;
        carry_in = 1;
        
        #1 assert(y === -8'd3 & carry === 1'b0) else $fatal(1, "wrong output for a %b b %b y=%b", a, b, y);
        #1 assert(y2 === -8'd3 & carry2 === 1'b0) else $fatal(1, "wrong ripple output for a %b b %b y=%b", a, b, y2);

        a = 8'd127;
        b = 8'd1;
        carry_in = 0;
        
        #1 assert(y === -8'd128 & carry === 1'b0) else $fatal(1, "wrong output for a %b b %b y=%b", a, b, y);
        #1 assert(y2 === -8'd128 & carry2 === 1'b0) else $fatal(1, "wrong ripple output for a %b b %b y=%b", a, b, y2);

        a = -8'd128;
        b = 8'd1;
        carry_in = 1;
        
        #1 assert(y === 8'd127 & carry === 1'b1) else $fatal(1, "wrong output for a %b b %b y=%b", a, b, y);
        #1 assert(y2 === 8'd127 & carry2 === 1'b1) else $fatal(1, "wrong ripple output for a %b b %b y=%b", a, b, y2);

        a = 8'd11;
        b = 8'd1;
        carry_in = 0;
        
        #1 assert(y === 8'd12 & carry === 1'b0) else $fatal(1, "wrong output for a %b b %b y=%b", a, b, y);
        #1 assert(y2 === 8'd12 & carry2 === 1'b0) else $fatal(1, "wrong ripple output for a %b b %b y=%b", a, b, y2);

        $display("All test passed");
        $finish;
    end
endmodule

