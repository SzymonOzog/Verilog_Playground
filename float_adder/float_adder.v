module float_adder_e4m3(
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

        reg[3:0] a_e_aligned;
        reg[3:0] b_e_aligned;

        wire[3:0] a_m = (a_e == 4'b0) ? {1'b0, a[2:0]} : {1'b1, a[2:0]};
        wire[3:0] b_m = (b_e == 4'b0) ? {1'b0, b[2:0]} : {1'b1, b[2:0]};

        reg[3:0] a_m_aligned;
        reg[3:0] b_m_aligned;

        reg[3:0] y_e;
        reg[2:0] y_m;

        reg[4:0] diff;

        reg[3:0] shift_amt;

        reg[4:0] m_sum;
        reg[3:0] e_sum;

        reg round_up;
        reg[2:0] lzd;

        wire sub_borrow = (m_sum_tmp[4] & (a_s ^ b_s));
        wire[4:0] m_sum_tmp = !(a_s ^ b_s) ? a_m_aligned + b_m_aligned :
                             a_s           ? b_m_aligned - a_m_aligned : 
                                             a_m_aligned - b_m_aligned;

        always @ (*)
        begin
            diff = a_e - b_e;
            if (diff[4]) begin
                shift_amt = ~(diff[3:0]) + 1'b1;
                a_m_aligned = a_m >> shift_amt;
                a_e_aligned = a_e + shift_amt;
                b_m_aligned = b_m;
                b_e_aligned = b_e;
                e_sum = b_e;
            end 
            else
            begin
                shift_amt = diff[3:0];
                a_m_aligned = a_m;
                a_e_aligned = a_e;
                b_m_aligned = b_m >> shift_amt;
                b_e_aligned = b_e + shift_amt;
                e_sum = a_e;
            end
                                               
            m_sum = sub_borrow ? ~(m_sum_tmp) + 1'b1 : m_sum_tmp;
            
            lzd = 3'd1;
            if (m_sum[4])      lzd = 3'd0;
            else if (m_sum[3]) lzd = 3'd1;
            else if (m_sum[2]) lzd = 3'd2;
            else if (m_sum[1]) lzd = 3'd3;
            else if (m_sum[0]) lzd = 3'd4;

            if (m_sum == 5'd0)
            begin
                e_sum = 4'd0;
            end

            round_up = m_sum[0] && m_sum[1];
            if (lzd == 3'd0)
            begin
                m_sum = m_sum >> 1;
                e_sum = e_sum + 1;
            end
            else
            begin
                m_sum = m_sum << (lzd-1);
                e_sum = e_sum - (lzd-1);
            end
            m_sum = round_up ? m_sum + 1'b1 : m_sum;
        end

        assign y[7] = (a_s & b_s) || sub_borrow;
        assign y[6:3] = e_sum;
        assign y[2:0] = m_sum[2:0];
        assign is_output_valid = 1'b1;
endmodule

module float_adder_bf16(
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

        reg[7:0] a_e_aligned;
        reg[7:0] b_e_aligned;

        wire[7:0] a_m = (a_e == 8'b0) ? {1'b0, a[6:0]} : {1'b1, a[6:0]};
        wire[7:0] b_m = (b_e == 8'b0) ? {1'b0, b[6:0]} : {1'b1, b[6:0]};

        reg[7:0] a_m_aligned;
        reg[7:0] b_m_aligned;

        reg[7:0] y_e;
        reg[6:0] y_m;

        reg[8:0] diff;

        reg[7:0] shift_amt;

        reg[8:0] m_sum;
        reg[7:0] e_sum;

        reg round_up;
        reg[3:0] lzd;

        wire sub_borrow = (m_sum_tmp[8] & (a_s ^ b_s));
        wire[8:0] m_sum_tmp = !(a_s ^ b_s) ? a_m_aligned + b_m_aligned :
                             a_s            ? b_m_aligned - a_m_aligned : 
                                                a_m_aligned - b_m_aligned;

        always @ (*)
        begin
            diff = a_e - b_e;
            if (diff[8]) begin
                shift_amt = ~(diff[7:0]) + 1'b1;
                a_m_aligned = a_m >> shift_amt;
                a_e_aligned = a_e + shift_amt;
                b_m_aligned = b_m;
                b_e_aligned = b_e;
                e_sum = b_e;
            end 
            else
            begin
                shift_amt = diff[7:0];
                a_m_aligned = a_m;
                a_e_aligned = a_e;
                b_m_aligned = b_m >> shift_amt;
                b_e_aligned = b_e + shift_amt;
                e_sum = a_e;
            end
                               
            m_sum = sub_borrow ? ~(m_sum_tmp) + 1'b1 : m_sum_tmp;
            //by default setting this to 1 does nothing
            lzd = 4'd1;
            if (m_sum[8])      lzd = 4'd0;
            else if (m_sum[7]) lzd = 4'd1;
            else if (m_sum[6]) lzd = 4'd2;
            else if (m_sum[5]) lzd = 4'd3;
            else if (m_sum[4]) lzd = 4'd4;
            else if (m_sum[3]) lzd = 4'd5;
            else if (m_sum[2]) lzd = 4'd6;
            else if (m_sum[1]) lzd = 4'd7;
            else if (m_sum[0]) lzd = 4'd8;

            if (m_sum == 8'd0)
            begin
                e_sum = 8'd0;
            end

            round_up = m_sum[0] && m_sum[1];
            if (lzd == 4'd0)
            begin
                m_sum = m_sum >> 1;
                e_sum = e_sum + 1;
            end
            else
            begin
                m_sum = m_sum << (lzd-1);
                e_sum = e_sum - (lzd-1);
            end
            m_sum = round_up ? m_sum + 1'b1 : m_sum;
        end

        assign y[15] = (a_s & b_s) || sub_borrow;
        assign y[14:7] = e_sum;
        assign y[6:0] = m_sum[6:0];
        assign is_output_valid = 1'b1;
endmodule
