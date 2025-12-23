module multiplier_int8(
        input wire[7:0] a,
        input wire[7:0] b,
        output wire[7:0] y,
        output wire overflow 
        );

        wire[7:0] a0;
        wire[7:0] a1;
        wire[7:0] a2;
        wire[7:0] a3;
        wire[7:0] a4;
        wire[7:0] a5;
        wire[7:0] a6;
        wire[7:0] a7;

        assign a0 = b[0] ? a : 8'b0;
        assign a1 = b[1] ? a : 8'b0;
        assign a2 = b[2] ? a : 8'b0;
        assign a3 = b[3] ? a : 8'b0;
        assign a4 = b[4] ? a : 8'b0;
        assign a5 = b[5] ? a : 8'b0;
        assign a6 = b[6] ? a : 8'b0;
        assign a7 = b[7] ? a : 8'b0;

        wire[8:0] y0;
        wire[8:0] y1;
        wire[8:0] y2;
        wire[8:0] y3;
        wire[8:0] y4;
        wire[8:0] y5;
        wire[8:0] y6;
        wire[8:0] y7;

        
        ripple_adder8 adder0((a0>>1), a1, 1'b0, y0[7:0] ,y0[8]);
        ripple_adder8 adder1(y0[8:1], a2, 1'b0, y1[7:0], y1[8]);
        ripple_adder8 adder2(y1[8:1], a3, 1'b0, y2[7:0], y2[8]);
        ripple_adder8 adder3(y2[8:1], a4, 1'b0, y3[7:0], y3[8]);
        ripple_adder8 adder4(y3[8:1], a5, 1'b0, y4[7:0], y4[8]);
        ripple_adder8 adder5(y4[8:1], a6, 1'b0, y5[7:0], y5[8]);
        ripple_adder8 adder6(y5[8:1], a7, 1'b0, y6[7:0], y6[8]);

        assign y[0] = a0[0];
        assign y[1] = y0[0];
        assign y[2] = y1[0];
        assign y[3] = y2[0];
        assign y[4] = y3[0];
        assign y[5] = y4[0];
        assign y[6] = y5[0];
        assign y[7] = y6[0];

        assign overflow = (y6[1] | y6[2] | y6[3] | y6[4] | y6[5] | y6[6] | y6[7] | y6[8]);
endmodule
