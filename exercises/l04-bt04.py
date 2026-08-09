#!/usr/bin/env python3
# Viết chương trình mô phỏng trò chơi Kéo - Búa - Bao giữa người và máy.
# Quy ước:
# - Kéo > Bao
# - Búa > Kéo
# - Bao > Búa

import random

# dict chứa các lựa chọn khả thi
kbb_dict = {
    "keo": "Kéo",
    "bua": "Búa",
    "bao": "Bao"
}

# get_kbb_choice: trả về một lựa chọn ngẫu nhiên từ kbb_dict
def get_kbb_choice():
    """Trả về một lựa chọn ngẫu nhiên từ kbb_dict"""
    return random.choice(tuple(kbb_dict.keys()))

