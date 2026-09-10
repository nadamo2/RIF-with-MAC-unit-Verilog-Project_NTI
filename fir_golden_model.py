import numpy as np
from scipy.signal import firwin

DEPTH = 8        
WIDTH = 16          
FRAC_BITS = WIDTH - 1 
SCALE = 2 ** FRAC_BITS  
INT_MIN = -(2 ** (WIDTH - 1))      
INT_MAX = (2 ** (WIDTH - 1)) - 1   

N_SAMPLES = 40      

def to_q15(x):
    val = int(round(x * SCALE))
    return max(INT_MIN, min(INT_MAX, val))


def to_hex16(x_int):
    return format(x_int & 0xFFFF, '04x')

def to_hex35(x_int):
    mask = (1 << 35) - 1
    return format(x_int & mask, '09x')

cutoff_normalized = 0.25  
h_float = firwin(numtaps=DEPTH, cutoff=cutoff_normalized)

h_q15 = [to_q15(h) for h in h_float]

print("=" * 60)
print("Coefficients (float -> Q1.15 integer):")
for k, (hf, hi) in enumerate(zip(h_float, h_q15)):
    print(f"  h{k}: float={hf:+.6f}  ->  Q1.15={hi:6d}  hex={to_hex16(hi)}")

print("\nVerilog parameter lines (copy-paste into MAC_unit):")
for k, hi in enumerate(h_q15):
    print(f"parameter signed [width-1:0] H{k} = 16'sd{hi};   // {h_float[k]:+.6f}")


n = np.arange(N_SAMPLES)
x_float = 0.5 * np.sin(2 * np.pi * 0.05 * n)  
x_q15 = [to_q15(v) for v in x_float]

print("\n" + "=" * 60)
print("Input samples (float -> Q1.15 integer), first 10 shown:")
for k in range(10):
    print(f"  x[{k}]: float={x_float[k]:+.6f}  ->  Q1.15={x_q15[k]:6d}  hex={to_hex16(x_q15[k])}")

y_raw = [] 
for out_idx in range(DEPTH - 1, N_SAMPLES):
    acc = 0
    for k in range(DEPTH):
        acc += h_q15[k] * x_q15[out_idx - k]
    y_raw.append(acc)

print("\n" + "=" * 60)
print("Reference output (raw integer — compare directly with Data_Mac_Out):")
for idx, val in enumerate(y_raw[:10]):
    real_value = val / (SCALE * SCALE) 
    print(f"  y[{idx + DEPTH - 1}]: raw={val:12d}   (real value ~= {real_value:+.6f})")


out_dir = "."

with open(f"{out_dir}/input_samples.hex", "w") as f:
    for v in x_q15:
        f.write(to_hex16(v) + "\n")

with open(f"{out_dir}/expected_output.txt", "w") as f:
    for idx, val in enumerate(y_raw):
        f.write(f"{val}\n")

with open(f"{out_dir}/coefficients.v", "w") as f:
    f.write("// Auto-generated Q1.15 coefficients from Python golden model\n")
    for k, hi in enumerate(h_q15):
        f.write(f"parameter signed [width-1:0] H{k} = 16'sd{hi};\n")

with open(f"{out_dir}/expected_output.hex", "w") as f:
    for val in y_raw:
        f.write(to_hex35(val) + "\n")

print("\n" + "=" * 60)
print("Files exported:")
print(f"  {out_dir}/input_samples.hex   -> download as $readmhe for testbench")
print(f"  {out_dir}/expected_output.txt -> for our reference")
print(f"  {out_dir}/coefficients.v      -> needed parameters")

