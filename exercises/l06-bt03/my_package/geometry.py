#!/usr/bin/env python3
# MSSV: 25410291
# l06-bt03
# my_package/geometry.py
# Tính diện tích, chu vi hình vuông, hình tròn

def dien_tich(**kwargs):
    if 'canh' in kwargs:
        return kwargs['canh'] * kwargs['canh']
    if 'ban_kinh' in kwargs:
        return kwargs['ban_kinh'] * kwargs['ban_kinh'] * 3.14

def chu_vi(**kwargs):
    if 'canh' in kwargs:
        return 4 * kwargs['canh']
    if 'ban_kinh' in kwargs:
        return 2 * kwargs['ban_kinh'] * 3.14
