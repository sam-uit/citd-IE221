#!/usr/bin/env python3
# b03-bt03.py
# Giải phương trình ax^2 + bx + c = 0

a = float(input("Nhập a: "))
b = float(input("Nhập b: "))
c = float(input("Nhập c: "))

delta = b**2 - 4*a*c

if delta < 0:
    print("Phương trình vô nghiệm")
elif delta == 0:
    print("Phương trình có nghiệm kép")
else:
    print("Phương trình có hai nghiệm phân biệt")
    x1 = (-b + delta**0.5) / (2*a)
    x2 = (-b - delta**0.5) / (2*a)
    print(f"x1 = {x1}, x2 = {x2}")
