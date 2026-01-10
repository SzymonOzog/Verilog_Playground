module float_multiplier_e4m3(
        input wire[7:0] a,
        input wire[7:0] b,
        input wire clock,
        input wire reset,
        output wire[7:0] y,
        output wire is_output_valid
        );

        wire a_s = a[7];
        wire b_s = b[7];

        wire[3:0] a_e = a[6:3];
        wire[3:0] b_e = b[6:3];


        wire[3:0] a_m = {1'b1, a[2:0]};
        wire[3:0] b_m = {1'b1, b[2:0]};

        reg[4:0] y_e;
        reg[4:0] y_e_next;

        reg[4:0] y_m;
        reg[4:0] y_m_next;
        wire[7:0] y_m_mul;

        reg[1:0] curr_state;
        reg[1:0] next_state;

        reg next_valid;
        reg valid;

        parameter MUL = 2'd1;
        parameter NORM = 2'd2;
        parameter BIAS = 4'd7;

        assign y_m_mul = (a_m * b_m);

        always @ (posedge clock or posedge reset)
        begin
            if (reset)
            begin
                curr_state <= MUL;
                next_state <= MUL;
                y_e <= 5'd0;
                y_m <= 5'd0;
                y_e_next <= 5'd0;
                y_m_next <= 5'd0;
                valid <= 1'b0;
                next_valid <= 1'b0;
            end
            else
            begin
                curr_state <= next_state;
                y_m <= y_m_next;
                y_e <= y_e_next;
                valid <= next_valid;
            end
        end

        always @ (*)
        begin
            case(curr_state)
                MUL:
                begin
                    if (a == 8'b00000000 || 
                        a == 8'b10000000 || 
                        b == 8'b00000000 || 
                        b == 8'b10000000 )
                    begin
                        y_e_next = 5'd0;
                        y_m_next = 5'd0;
                        next_valid = 1'b1;
                    end
                    else 
                    begin
                        y_m_next = y_m_mul[7:3];
                        y_e_next = a_e + b_e - BIAS;
                        next_state = NORM;
                    end
                end

                NORM:
                begin
                    next_valid = y_m[3];
                    if (!next_valid)
                    begin
                        y_m_next = y_m >> 1;
                        y_e_next = y_e + 1'b1;
                    end
                end
            endcase
        end

        assign y[7] = a_s ^ b_s;
        assign y[6:3] = y_e;
        assign y[2:0] = y_m[2:0];
        assign is_output_valid = valid;
endmodule

module float_multiplier_bf16(
        input wire[15:0] a,
        input wire[15:0] b,
        input wire clock,
        input wire reset,
        output wire[15:0] y,
        output wire is_output_valid
        );

        wire a_s = a[15];
        wire b_s = b[15];

        wire[7:0] a_e = a[14:7];
        wire[7:0] b_e = b[14:7];


        wire[6:0] a_m = {1'b1, a[6:0]};
        wire[6:0] b_m = {1'b1, b[6:0]};

        reg[7:0] y_e;
        reg[7:0] y_e_next;

        reg[6:0] y_m;
        reg[6:0] y_m_next;
        wire[11:0] y_m_mul;

        reg[1:0] curr_state;
        reg[1:0] next_state;

        reg next_valid;
        reg valid;

        parameter MUL = 2'd1;
        parameter NORM = 2'd2;
        parameter BIAS = 4'd7;

        assign y_m_mul = (a_m * b_m);

        always @ (posedge clock or posedge reset)
        begin
            if (reset)
            begin
                curr_state <= MUL;
                next_state <= MUL;
                y_e <= 8'd0;
                y_m <= 7'd0;
                y_e_next <= 8'd0;
                y_m_next <= 7'd0;
                valid <= 1'b0;
                next_valid <= 1'b0;
            end
            else
            begin
                curr_state <= next_state;
                y_m <= y_m_next;
                y_e <= y_e_next;
                valid <= next_valid;
            end
        end

        always @ (*)
        begin
            case(curr_state)
                MUL:
                begin
                    if (a == 16'h00 || a == 16'h80 || 
                        b == 16'h00 || b == 16'h80 )
                    begin
                        y_e_next = 5'd0;
                        y_m_next = 5'd0;
                        next_valid = 1'b1;
                    end
                    else 
                    begin
                        y_m_next = y_m_mul[11:3];
                        y_e_next = a_e + b_e - BIAS;
                        next_state = NORM;
                    end
                end

                NORM:
                begin
                    next_valid = y_m[5];
                    if (!next_valid)
                    begin
                        y_m_next = y_m >> 1;
                        y_e_next = y_e + 1'b1;
                    end
                end
            endcase
        end

        assign y[15] = a_s ^ b_s;
        assign y[14:7] = y_e;
        assign y[6:0] = y_m[6:0];
        assign is_output_valid = valid;
endmodule
