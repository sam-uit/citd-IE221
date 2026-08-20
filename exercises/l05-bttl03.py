# Viết hàm tính căn bậc n từ một số thựuc.
# Viết hàm tính giá trị bình phương của một số dương.
# Viêt hàm kiểm tra một số nhập vào là số chẵn có giá trị âm. Đúng trả về True, sai trả về False.
# Viết hàm kiểm tra một số nhập vào: nếu là số âm có giá trị lẻ thì trả về -1, nếu là số dương có giá trị chẵn thì trả về 1, trường hợp khác trả về 0.
# Viết hàm kiểm tra giá trị nhập vào phải thuộc đoạn [-89, 90], nếu sai bắt nhập lại.

def can_bac_n(x: float) -> float:
    """
    Tính căn bậc n của một số thực.
    """
    n: float = 0
    n = x ** (1/x)
    return n

def binh_phuong(x: float) -> float:
    """
    Tính giá trị bình phương của một số dương.
    """
    if x > 0:
        return x ** 2
    else:
        return 0

def kiem_tra_chan_am(x: float) -> bool:
    if x % 2 == 0 and x < 0:
        return True
    else:
        return False

def kiem_tra_am_duong(x: float) -> int:
    if x < 0:
        return -1
    elif x > 0:
        return 1
    else:
        return 0

def kiem_tra_so_hop_le(x: float) -> bool:
    while True:
        x = float(input("Vui long nhap so [-89, 90]: "))
        if x >= -89 and x <= 90:
            return True
        else:
            print("So khong hop le. Vui long nhap lai.")
