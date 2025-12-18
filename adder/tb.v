
module tb;
    reg[7:0] a;
    reg[7:0] b;
    reg carry_in;
    wire[7:0] y;
    wire carry;

    adder8 adder(a, b, carry_in, y, carry);


    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        a = 8'd5;
        b = 8'd5;
        carry_in = 0;
        
        #1 assert(y === 8'd10) else $fatal(1, "wrong output for a %b b %b y=%b", a, b, y);

        a = 8'd8;
        b = 8'd5;
        carry_in = 0;
        
        #1 assert(y === 8'd13) else $fatal(1, "wrong output for a %b b %b y=%b", a, b, y);

        a = 8'd8;
        b = 8'd5;
        carry_in = 1;
        
        #1 assert(y === 8'd3) else $fatal(1, "wrong output for a %b b %b y=%b", a, b, y);

        $display("All test passed");
        $finish;
    end
endmodule

