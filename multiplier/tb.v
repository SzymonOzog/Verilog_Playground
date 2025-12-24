module tb;
    reg[7:0] a;
    reg[7:0] b;
    wire[7:0] y;
    wire overflow;

    multiplier_int8 multiplier(a, b, y, overflow);


    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        a = 8'd5;
        b = 8'd1;
        
        #1 assert(y === 8'd5 && overflow == 1'b0) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, 8'd5);

        a = 8'd5;
        b = 8'd2;
        
        #1 assert(y === 8'd10 && overflow == 1'b0) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, 8'd10);

        a = 8'd5;
        b = 8'd5;
        
        #1 assert(y === 8'd25 && overflow == 1'b0) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, 8'd25);

        a = 8'd5;
        b = 8'd0;
        
        #1 assert(y === 8'd0 && overflow == 1'b0) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, 8'd0);

        a = 8'd0;
        b = 8'd5;
        
        #1 assert(y === 8'd0 && overflow == 1'b0) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, 8'd0);

        a = 8'd1;
        b = 8'd5;
        
        #1 assert(y === 8'd5 && overflow == 1'b0) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, 8'd5);

        a = 8'd10;
        b = 8'd25;
        
        #1 assert(y === 8'd250 && overflow == 1'b0) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
            a, b, y, 8'd250);

        a = 8'd11;
        b = 8'd25;
        
        #1 assert(overflow == 1'b1) else $fatal(1, "wrong output for a %b b %b y=%b, overflow not detected", 
            a, b, y);

        $display("All test passed");
        $finish;
    end
endmodule

