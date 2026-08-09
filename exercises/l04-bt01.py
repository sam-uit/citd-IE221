#!/usr/bin/env python3
# Từ một chuỗi str_input được nhập vào từ bàn
# phím. Hãy viết lệnh thực hiện các chức năng sau:
# 1. Tính độ dài chuỗi.
# 2. Đếm và in các ký tự đặc biệt: ! @ # $ % ^ & * ( ) # - = + . /
# 3. Đếm và in các ký tự chữ cái từ [a-z]
# 4. Đếm và in các ký tự chữ số từ [0-9]
# 5. Đếm và in các ký tự chữ [A-Z]

SPECIAL_CHARS = "!@#$%^&*()-=+./"

str_input = input("Nhập chuỗi: ")

if len(str_input) == 0:
    print("[!] Chuỗi rỗng.")
    exit()

# 1. Tính độ dài chuỗi.
print("+ Độ dài chuỗi:", len(str_input))

# 2. Đếm và in các ký tự đặc biệt: ! @ # $ % ^ & * ( ) # - = + . /
for char in SPECIAL_CHARS:
    if char in str_input:
        print(f"+ Ký tự đặc biệt: {char}", end=None)

# 3. Đếm và in các ký tự chữ cái từ [a-z]
for char in str_input:
    if char.islower():
        print(f"+ Ký tự chữ thường: {char}")

# 4. Đếm và in các ký tự chữ số từ [0-9]
for char in str_input:
    if char.isdigit():
        print(f"+ Ký tự chữ số: {char}")

# 5. Đếm và in các ký tự chữ [A-Z]
for char in str_input:
    if char.isupper():
        print(f"+ Ký tự chữ HOA: {char}")
