#!/usr/bin/env python3
# Dùng các kỹ thuật tham số dạng *args, **kwargs...
# thiết kế hàm tính chu vi hình vuông, chữ nhật, tròn.

def chu_vi_hinh_vuong(*canh):
    if len(canh) != 1:
        return 0
    return 4 * canh[0]

def chu_vi_hinh_chu_nhat(*canh):
    if len(canh) != 2:
        return 0
    return 2 * (canh[0] + canh[1])

def chu_vi_hinh_tron(*ban_kinh):
    if len(ban_kinh) != 1:
        return 0
    return 2 * 3.14 * ban_kinh[0]

def chu_vi(*args):
    if len(args) == 1 and "vuong" in args:
        return 4 * args[0]
    elif len(args) == 2:
        return 2 * (args[0] + args[1])
    elif len(args) == 1 and circle:
        return 2 * 3.14 * args[0]
    else:
        return 0

print(chu_vi(5))
print(chu_vi(5, 3))
print(chu_vi(circle=True, 5))
