#!/usr/bin/env python3
# MSSV: 25410291
# l06-bt05
# matrix_ops.py

import numpy as np

# Tạo ma trận 3x3 ngẫu nhiên.
def tao_ma_tran_ngau_nhien(bac):
    return np.random.rand(bac, bac)

# Tính định thức, ma trận nghịch đảo.
def tinh_dinh_thuc(ma_tran):
    return np.linalg.det(ma_tran)

def tinh_ma_tran_nghich_dao(ma_tran):
    return np.linalg.inv(ma_tran)
