#!/usr/bin/env python3
# MSSV: 25410291
# l06-bt03
# main.py

from my_package.converter import cm_to_m, m_to_km
from my_package.geometry import dien_tich, chu_vi

if __name__ == "__main__":
    gia_tri = 5
    print(f"[i] Giá trị: {gia_tri}")
    print(f"[i] Tính diện tích hình vuông cạnh = {gia_tri}: {dien_tich(canh=gia_tri)}")
    print(f"[i] Tính chu vi hình vuông cạnh = {gia_tri}: {chu_vi(canh=gia_tri)}")
    print(f"[i] Tính diện tích hình tròn bán kính = {gia_tri}: {dien_tich(ban_kinh=gia_tri)}")
    print(f"[i] Tính chu vi hình tròn bán kính = {gia_tri}: {chu_vi(ban_kinh=gia_tri)}")
    print(f"[i] Đổi đơn vị {gia_tri * 100} cm -> m: {cm_to_m(gia_tri * 100)} m")
    print(f"[i] Đổi đơn vị {gia_tri * 1000} m -> km: {m_to_km(gia_tri * 1000)} km")
