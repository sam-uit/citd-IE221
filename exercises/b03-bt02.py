#!/usr/bin/env python3
# b03-bt02.py
# Giải bài tập: ax + b = 0

a = float(input("Nhập a: "))
b = float(input("Nhập b: "))

if a == 0:
    if b == 0:
        print(f"Phương trình {a}x + {b} = 0 có vô số nghiệm")
    else:
        print(f"Phương trình {a}x + {b} = 0 vô nghiệm")
else:
    x = -b / a
    print(f"Phương trình {a}x + {b} = 0 có nghiệm x = {x}")
