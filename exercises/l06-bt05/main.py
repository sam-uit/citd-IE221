#!/usr/bin/env python3
# MSSV: 25410291
# l06-bt05
# main.py

from matrix_ops import tao_ma_tran_ngau_nhien, tinh_dinh_thuc, tinh_ma_tran_nghich_dao

if __name__ == "__main__":
    print("Ma trận ngẫu nhiên: A (3x3)")
    A = tao_ma_tran_ngau_nhien(3)
    print(A)

    print("Định thức:", tinh_dinh_thuc(A))

    print("Ma trận nghịch đảo của A:")
    A_inv = tinh_ma_tran_nghich_dao(A)
    print(A_inv)
