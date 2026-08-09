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

# play: chơi một lượt của trò chơi Kéo - Búa - Bao
def play():
    """Chơi một lượt của trò chơi Kéo - Búa - Bao"""
    print("[i] Các lựa chọn: ")

    # Các lựa chọn của trò chơi
    choices = {1: "keo", 2: "bua", 3: "bao"}

    # In ra các lựa chọn cho người chơi
    counter = 0
    for _, value in kbb_dict.items():
        counter += 1
        print(f"\t{counter}: {value}")

    your_choice = input("[i] Nhập lựa chọn của bạn (1, 2, 3; 0 để thoát): ")
    while not your_choice.isdigit():
        your_choice = input("[i] Nhập lựa chọn của bạn (1, 2, 3; 0 để thoát): ")
    if int(your_choice) == 0:
        exit(0)

    print(f"[i] Bạn chọn:\t {kbb_dict[choices[int(your_choice)]]}")

    computer_choice = get_kbb_choice()
    print(f"[i] Máy chọn:\t {kbb_dict[computer_choice]}")

    result = winner(choices[int(your_choice)], computer_choice)
    print(f"[>] Kết quả:\t {result_dict[result]}")

