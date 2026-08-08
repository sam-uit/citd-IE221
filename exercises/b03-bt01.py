#!/usr/bin/env python3
# b03-bt01.py

your_gpa = float(input("Vui lòng nhập điểm GPA: "))

if your_gpa < 3.5:
    print("Đánh giá: Học lực Kém")
elif 3.5 <= your_gpa < 5.0:
    print("Đánh giá: Học lực Yếu")
elif 5.0 <= your_gpa < 7.0:
    print("Đánh giá: Học lực Trung Bình")
elif 7.0 <= your_gpa < 8.0:
    print("Đánh giá: Học lực Khá")
elif 8.0 <= your_gpa < 9.0:
    print("Đánh giá: Học lực Giỏi")
elif 9.0 <= your_gpa < 10.0:
    print("Đánh giá: Học lực Xuất Sắc")
else:
    print("Giá trị GPA không hợp lệ.")
