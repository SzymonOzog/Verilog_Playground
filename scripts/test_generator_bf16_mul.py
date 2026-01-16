import torch

def t_to_hex(t):
    return hex(t.view(torch.int16)[0].item() & 0xFFFF)[2:]

if __name__ == "__main__":
    a_vals = [1, 0, -1, -0.75, 200, 1.9921875]
    b_vals = [-1, 0, -1, 1.75, 0.001, 1.75]

    for a, b in zip(a_vals, b_vals):
        a_t = torch.tensor([a], dtype=torch.bfloat16)
        b_t = torch.tensor([b], dtype=torch.bfloat16)
        c_t = a_t * b_t
        a_h = t_to_hex(a_t)
        b_h = t_to_hex(b_t)
        c_h = t_to_hex(c_t)

        test = f"""
        a_bf16 = 16'h{a_h};
        b_bf16 = 16'h{b_h};
        expected_bf16 = 16'h{c_h};
        #1 reset = 1'b1;
        #1 reset = 1'b0;
        #10 assert(y_bf16 === expected_bf16 & is_output_valid_bf16) else $fatal(1, "wrong output for a %b b %b y=%b, expected %b", 
                                                         a_bf16, b_bf16, y_bf16, expected_bf16);"""
        print(test)


