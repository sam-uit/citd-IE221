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
