#!/usr/bin/env python3
# MSSV: 25410291
# l06-bt01
# main.py

import random
import math_utils as mu

def main():
    x = random.randint(0, 10)
    y = random.randint(0, 10)
    print(f"Test with x: {x}, y: {y}")
    print(f"[i] sum: {mu.add(x, y)}")
    print(f"[i] subtract: {mu.subtract(x, y)}")
    print(f"[i] multiply: {mu.multiply(x, y)}")
    try:
        print(f"[i] divide: {mu.divide(x, y)}")
    except ValueError as e:
        print(f"[x] Error: {e}")

if __name__ == "__main__":
    main()
