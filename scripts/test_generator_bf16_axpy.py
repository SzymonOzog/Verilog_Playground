import torch

def load_axpy_results_bf16(path: str) -> torch.Tensor:
    hex_lines = []
    with open(path, "r") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("//"):
                continue
            line = line.replace(" ", "")
            hex_lines.append(line)
    rows = []
    for s in hex_lines:
        n16 = len(s) // 4
        vals_u16 = [int(s[i:i+4], 16) for i in range(0, len(s), 4)]
        t_i16 = torch.tensor(vals_u16, dtype=torch.int32).to(torch.int16)
        t_bf16 = t_i16.view(torch.bfloat16)
        rows.append(t_bf16)
    return torch.stack(rows, dim=0).flatten()



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

    t = load_axpy_results_bf16("axpy_results.txt")
    argmax = (t-out).abs().argmax()
    print("mean difference", (t-out).abs().mean().item())
    print("max difference", (t-out).abs().max().item(),
          "for values:", t[argmax].item(), out[argmax].item())
