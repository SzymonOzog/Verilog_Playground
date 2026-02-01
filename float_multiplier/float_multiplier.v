module float_multiplier_e4m3(
        input wire[7:0] a,
        input wire[7:0] b,
        input wire clock,
        output wire[7:0] y
        );

        wire a_s = a[7];
        wire b_s = b[7];

        wire[3:0] a_e = a[6:3];
        wire[3:0] b_e = b[6:3];

        wire[3:0] a_m = {1'b1, a[2:0]};
        wire[3:0] b_m = {1'b1, b[2:0]};

        reg[3:0] y_e;
        reg[2:0] y_m;
        wire[7:0] y_m_mul;

        reg[3:0] m_discard;
        reg round;
        wire G;
        wire R;
        wire S;
        assign G = m_discard[3];
        assign R = m_discard[2];
        assign S = m_discard[1] | m_discard[0];

        parameter BIAS = 4'd7;

        assign y_m_mul = (a_m * b_m);

        always @ (*)
        begin
            if (a[6:0] == 7'b0 || b[6:0] == 7'b0)
            begin
                y_e = 4'd0;
                y_m = 3'd0;
                m_discard = 4'd0;
            end
            else 
            begin
                y_e = a_e + b_e - BIAS;
                if(y_m_mul[7])
                begin
                    y_m = y_m_mul[6:4];
                    m_discard[3:0] = y_m_mul[3:0];
                    y_e = y_e + 1'b1;
                end
                else
                begin
                    y_m = y_m_mul[5:3];
                    m_discard[3:1] = y_m_mul[2:0];
                    m_discard[0] = 1'b1;
                    y_e = y_e;
                end
                round = G & (R | S | y_m[0]);
                y_m = y_m + round;
            end
        end

        assign y[7] = a_s ^ b_s;
        assign y[6:3] = y_e;
        assign y[2:0] = y_m[2:0];
endmodule

module float_multiplier_bf16(
        input wire[15:0] a,
        input wire[15:0] b,
        input wire clock,
        output wire[15:0] y
        );

        wire a_s = a[15];
        wire b_s = b[15];

        wire[7:0] a_e = a[14:7];
        wire[7:0] b_e = b[14:7];

        wire[7:0] a_m = (a_e == 8'b0) ? {1'b0, a[6:0]} : {1'b1, a[6:0]};
        wire[7:0] b_m = (b_e == 8'b0) ? {1'b0, b[6:0]} : {1'b1, b[6:0]};

        reg[7:0] y_e;

        reg[6:0] y_m;
        wire[15:0] y_m_mul;

        reg[7:0] m_discard;
        reg round;
        wire G;
        wire R;
        wire S;
        assign G = m_discard[7];
        assign R = m_discard[6];
        assign S = m_discard[5] | m_discard[4] | m_discard[3] | m_discard[2] | m_discard[1] | m_discard[0];

        parameter BIAS = 8'd127;

        assign y_m_mul = (a_m * b_m);

        always @ (*)
        begin
            if (a == 16'h00 || a == 16'h80 || 
                b == 16'h00 || b == 16'h80 )
            begin
                y_e = 7'd0;
                y_m = 8'd0;
            end
            else 
            begin
                y_e = a_e + b_e - BIAS;
                y_e = (a_e == 8'b0) ? y_e + 1 : y_e;
                y_e = (b_e == 8'b0) ? y_e + 1 : y_e;
                if(y_m_mul[15])
                begin
                    y_m = y_m_mul[14:8];
                    m_discard[7:0] = y_m_mul[7:0];
                    y_e = y_e + 1'b1;
                end
                else
                begin
                    y_m = y_m_mul[13:7];
                    m_discard[7:1] = y_m_mul[6:0];
                    m_discard[0] = 1'b1;
                    y_e = y_e;
                end
                round = G & (R | S | y_m[0]);
                y_m = y_m + round;
            end
        end

        assign y[15] = a_s ^ b_s;
        assign y[14:7] = y_e;
        assign y[6:0] = y_m[6:0];
endmodule
