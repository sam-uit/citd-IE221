#!/usr/bin/env python3
# l04-bt03.py
# Viết hàm kiểm tra quá trình đăng nhập ID user và password khi login vào
# hệ thống phải thỏa mãn các tiêu chí sau:
#   ID User:
#      Là một chuỗi có độ dài ít nhất 6 ký tự và tối đa 24 ký tự.
#      Không chứa các ký tự đặc biệt: ! @ # $ % ^ & * ( ) - = +.
#      Không chứa khoảng trắng.
#   Password:
#      Có ít nhất 1 chữ cái thường nằm trong [a-z].
#      Có ít nhất 1 chữ số nằm trong [0-9].
#      Có ít nhất 1 chữ cái hoa nằm trong [A-Z].
#      Có ít nhất 1 ký tự đặc biệt nằm trong [$, #, @].
#      Độ dài mật khẩu tối thiểu là 6 ký tự
#      Độ dài mật khẩu tối đa là 24 ký tự.

SPECIAL_CHARS = "!@#$%^&*()-=+"
PASSWORD_MIN_LENGTH = 6
PASSWORD_MAX_LENGTH = 24
PASSWORD_SPECIAL_CHARS = "$#@"

def validate_login(id_user, password):
    """
    Hàm kiểm tra tính hợp lệ của id_user và password.
    Chỉ trả về True nếu cả id_user và password đều hợp lệ.
    Trả về False nếu id_user hoặc password không hợp lệ với bất kỳ tiêu chí nào.
    """

    # Nếu id_user hoặc password không được cung cấp, trả về False
    if not id_user or not password:
        return False

    # Kiểm tra độ dài của id_user
    if len(id_user) < PASSWORD_MIN_LENGTH or len(id_user) > PASSWORD_MAX_LENGTH:
        return False

    # Kiểm tra ký tự đặc biệt trong id_user
    for char in id_user:
        if char in SPECIAL_CHARS:
            return False
    # Kiểm tra khoảng trắng trong id_user
    if " " in id_user:
        return False

    # Kiểm tra độ dài của password
    if len(password) < PASSWORD_MIN_LENGTH or len(password) > PASSWORD_MAX_LENGTH:
        return False
    password_check = {
        'lower': False,
        'upper': False,
        'digit': False,
        'special': False,
    }
    # Tối thiểu 1 ký tự thường, 1 ký tự hoa, 1 ký tự số, 1 ký tự đặc biệt
    for char in password:
        if char.islower():
            password_check['lower'] = True
        elif char.isupper():
            password_check['upper'] = True
        elif char.isdigit():
            password_check['digit'] = True
        elif char in PASSWORD_SPECIAL_CHARS:
            password_check['special'] = True
        else:
            return False

    # Chỉ cần một tiêu chí không được đáp ứng, trả về False
    for value in password_check.values():
        if not value:
            return False

    # Nếu tất cả các tiêu chí đều được đáp ứng, trả về True
    return True

if __name__ == '__main__':
    id_user = input("[i] Nhập id_user: ").strip()
    password = input("[i] Nhập password: ").strip()

    # Chỉ thông báo chung chung, không phân biệt id_user và password
    # Tránh việc phán đoán.
    if validate_login(id_user, password):
        print("[v] Username hoặc/và Mật khẩu hợp lệ.")
        exit(0)
    else:
        print("[x] Username hoặc/và Mật khẩu không hợp lệ.")
        exit(1)
