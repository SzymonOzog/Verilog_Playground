module multiplier_int8(
        input wire[7:0] a,
        input wire[7:0] b,
        output wire[7:0] y
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

        wire[7:0] y0;
        wire[7:0] y1;
        wire[7:0] y2;
        wire[7:0] y3;

        
        wire[6:0] carry;
        ripple_adder8 adder0((a0>>1), a1, 1'b0, y0, carry[0]);
        ripple_adder8 adder1(a2, a3, 1'b0, y1, carry[1]);
        ripple_adder8 adder2(a4, a5, 1'b0, y2, carry[2]);
        ripple_adder8 adder3(a6, a7, 1'b0, y3, carry[3]);

        wire[7:0] y10;
        wire[7:0] y11;

        ripple_adder8 adder10((y0>>1), y1, 1'b0, y10, carry[4]);
        ripple_adder8 adder11(y2, y3, 1'b0, y11, carry[5]);

        wire[7:0] y20;

        ripple_adder8 adder20((y10>>1), y11, 1'b0, y20, carry[6]);

        assign y[0] = a0[0];
        assign y[1] = y0[0];
        assign y[2] = y10[0];
        assign y[3] = y20[0];
        assign y[4] = y20[1];
        assign y[5] = y20[2];
        assign y[6] = y20[3];
        assign y[7] = y20[4];
endmodule
