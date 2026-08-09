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

# result_dict: các kết quả khả thi của trò chơi
result_dict = {
    0: "Hòa!",
    1: "Bạn thắng!",
    2: "Máy thắng!"
}

# rule_dict: các quy tắc thắng của trò chơi
rule_dict = {
    "keo": "bao",
    "bao": "bua",
    "bua": "keo"
}

# get_kbb_choice: trả về một lựa chọn ngẫu nhiên từ kbb_dict
def get_kbb_choice():
    """Trả về một lựa chọn ngẫu nhiên từ kbb_dict"""
    return random.choice(tuple(kbb_dict.keys()))

# winner: xác định người chiến thắng dựa trên các lựa chọn
def winner(your_choice: str, computer_choice: str):
    """
    Xác định người chiến thắng dựa trên lựa chọn của người chơi và máy.
    Sử dụng rule_dict để xác định người chiến thắng.
    """
    if your_choice == computer_choice:
        return 0
    elif rule_dict[your_choice] == computer_choice:
        return 1
    else:
        return 2

