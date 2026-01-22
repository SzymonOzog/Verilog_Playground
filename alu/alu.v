module alu_e4m3(
        input wire[7:0] a,
        input wire[7:0] b,
        input wire[3:0] alu_ctrl,
        input wire clock,
        output wire[7:0] y
        );

        wire[7:0] mul_y;
        wire[7:0] add_y;

        float_adder_e4m3 adder(a, b, clock, add_y);
        float_multiplier_e4m3 multiplier(a, b, clock, mul_y);

        assign y = (alu_ctrl == 4'b0001) ? add_y :
                   (alu_ctrl == 4'b0010) ? mul_y : 8'd0;

endmodule

module alu_bf16(
        input wire[15:0] a,
        input wire[15:0] b,
        input wire[3:0] alu_ctrl,
        input wire clock,
        output wire[15:0] y
        );

        wire[15:0] mul_y;
        wire[15:0] add_y;

        float_adder_bf16 adder(a, b, clock, add_y);
        float_multiplier_bf16 multiplier(a, b, clock, mul_y);

        assign y = (alu_ctrl == 4'b0001) ? add_y :
                   (alu_ctrl == 4'b0010) ? mul_y : 8'd0;
endmodule
