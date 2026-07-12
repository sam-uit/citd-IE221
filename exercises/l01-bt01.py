# IE221 - Kỹ Thuật Lập Trình Python
# MSSV: 25410291
# Họ Tên: Đinh Xuân Sam
# Lớp: IE221.F33.LT.CNTT
# https://github.com/sam-uit/citd-IE221/blob/zero/exercises/l01-bt01.py

print("[i] IE221 - Bài 01 - Bài Tập 01")

# 2. Viết CT nhập thông tin từ bàn phím, sau đó in ra chuỗi, rồi kiểm tra kiểu dữ liệu nhập vào.

print("+========+")
print("[A] Nhập chuỗi, in chuỗi & kiểm tra kiểu dữ liệu.")
hovaten = input("[1] Vui lòng nhập họ và tên: ")
print(f"[2] Thông tin bạn nhập vào là: {hovaten}")
print("[3] Kiểu dữ liệu là: " + type(hovaten).__name__)

# 3. Viết chương trình nhập vào hai string. Sau đó dùng `""` hoặc "`+`" trong `print()` để kết hai string đó và xuất ra màn hình.

print("+========+")
print("[B] Nhập 2 string và nối cùng nhau trong print().")
chuoia = input("[1] Vui lòng nhập chuỗi a: ")
chuoib = input("[2] Vui lòng nhập chuỗi b: ")
print("[3] Chuỗi bạn vừa nhập là: " + chuoia + chuoib)

# 4. Viết lệnh nhập thông tin từ bàn phím, rồi xuất ra giá trị nhập, viết lệnh `input()` lồng trong lệnh `print()`.

print("+========+")
print("[C] Nhập thông tin từ bàn phím với `input()` lồng trong `print()`")
print("[2] Tên của bạn là: " + input("[1] Vui lòng nhập tên của bạn: "))
