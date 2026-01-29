import torch

def my_hex(item):
    hx = hex(item & 0xFFFF)[2:]
    while len(hx) < 4:
        hx = "0" + hx
    return hx

def t_to_hex(t):
    return "".join([my_hex(item.item() & 0xFFFF) for item in t.view(torch.int16)])

if __name__ == "__main__":
    torch.manual_seed(42)
    a = torch.randn(512, dtype=torch.bfloat16)
    b = torch.randn(512, dtype=torch.bfloat16)
    c = torch.randn(512, dtype=torch.bfloat16)
    out = a*b + c
    file_contents = ""
    vals = a.tolist() + b.tolist() + c.tolist() 
    for i in range(0, 512*3, 32):
        file_contents += t_to_hex(torch.tensor(vals[i:i+32], dtype=a.dtype)) + "\n"
    with open("axpy_vals.txt", "w") as f:
        f.write(file_contents)


    

