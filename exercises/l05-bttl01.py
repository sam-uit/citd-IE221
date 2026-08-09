#!/usr/bin/env python3
# Dùng các kỹ thuật tham số dạng *args, **kwargs... thiết kế hàm tính tổng, tích của nhiều số.

def tong_va_tich(*args):
    tong = 0
    tich = 1
    for arg in args:
        tong += arg
        tich *= arg
    return tong, tich

result = tong_va_tich(1, 2, 3)
print(f"Tổng: {result[0]}, Tích: {result[1]}")

def tong_va_tich_kwargs(**kwargs):
    return tong_va_tich(*kwargs.values())

result_kwargs = tong_va_tich_kwargs(a=1, b=2, c=3)
print(f"Tổng: {result_kwargs[0]}, Tích: {result_kwargs[1]}")
