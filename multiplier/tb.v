module tb;
    reg[7:0] a;
    reg[7:0] b;
    wire[7:0] y;

    multiplier_int8 multiplier(a, b, y);


    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        a = 8'd5;
        b = 8'd1;
        
        #1 assert(y === 8'd5) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, 8'd5);

        a = 8'd5;
        b = 8'd2;
        
        #1 assert(y === 8'd10) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, 8'd10);

        a = 8'd5;
        b = 8'd5;
        
        #1 assert(y === 8'd25) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, 8'd25);

        a = 8'd5;
        b = 8'd0;
        
        #1 assert(y === 8'd0) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, 8'd0);

        a = 8'd0;
        b = 8'd5;
        
        #1 assert(y === 8'd0) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, 8'd0);

        a = 8'd1;
        b = 8'd5;
        
        #1 assert(y === 8'd5) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, 8'd5);

        $display("All test passed");
        $finish;
    end
endmodule

