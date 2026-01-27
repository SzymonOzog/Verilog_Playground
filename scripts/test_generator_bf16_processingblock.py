import torch

def my_hex(item):
    hx = hex(item & 0xFFFF)[2:]
    while len(hx) < 4:
        hx = "0" + hx
    return hx

def t_to_hex(t):
    return "".join([my_hex(item.item() & 0xFFFF) for item in t.view(torch.int16)[0]])

if __name__ == "__main__":
    a = [0.2  for i in range(32)]
    b = [2 for i in range(32)]
    c = [0.2 for i in range(32)]

    a_t = torch.tensor([a], dtype=torch.bfloat16)
    b_t = torch.tensor([b], dtype=torch.bfloat16)
    c_t = torch.tensor([c], dtype=torch.bfloat16)
    out = (a_t * b_t) + c_t
    a_h = t_to_hex(a_t)
    b_h = t_to_hex(b_t)
    c_h = t_to_hex(c_t)
    out_h = t_to_hex(out)

    test = f"""
    load_data = 512'h{a_h};
    load_data = 512'h{b_h};
    load_data = 512'h{c_h};
    expected = 512'h{out_h};
    """
    print(test)


