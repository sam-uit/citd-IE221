#!/usr/bin/env python3
# Viết hàm kiểm tra để phát hiện chuỗi nhập vào có phải là một e-mail hay không?
# Chú ý: Nếu là các e-mail xuất phát từ Gmail, Yahoo, Hotmail, Outlook...
# (gọi tắt là tập luật tên miền e-mail) thì trước ký tự `@` là một chuỗi
# tối thiểu 6 ký tự, không chứa khoảng trắng và không chứa ký tự đặc biệt.
# Hãy khảo sát và tìm thêm các tên miền e-mail khác để bổ sung vào tập luật giới hạn trên.

# Lưu ý: Hàm (def) chưa được giới thiệu cho tới hiện tại là buổi học của l04.

ALLOWED_DOMAINS = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com', 'uit.edu.vn']

def validate_email(email):
    # Không chứa @ thì là không phải một địa chỉ email hợp lệ.
    if '@' not in email:
        return False

    # Tách username và domain dựa trên ký tự `@`.
    username, domain = email.split('@')

    # username phải tối thiểu 6 ký tự.
    if len(username) < 6:
        return False
    # username không chứa ký tự đặc biệt bao gồm khoảng trắng.
    if not username.isalnum():
        return False

    # domain phải là một trong các tên miền được phép.
    if domain not in ALLOWED_DOMAINS:
        return False

    # domain phải có ít 2 phần (tên miền và đuôi tên miền).
    # có nghĩa chia tách theo dấu . phải có ít nhất 2 phần.
    if len(domain.split('.')) < 2:
        return False
    else:
        domain_components = domain.split('.')
        # Nếu bất kỳ phần nào trong domain chứa ký tự đặc biệt,
        # bao gồm khoảng trắng, trả về False.
        for component in domain_components:
            if not component.isalnum():
                return False

# Gọi hàm validate_email để kiểm tra địa chỉ email nhập vào.
if __name__ == '__main__':
    print("[i] Các tên miền email được phép:", ', '.join(ALLOWED_DOMAINS))

    add_domain = input('[?] Bạn có muốn thêm tên miền email khác? (y/n): ')
    if add_domain.lower() == 'y':
        new_domain = input('[i] Nhập tên miền email: ')
        ALLOWED_DOMAINS.append(new_domain)
        print('[i] Các tên miền email được phép:', ', '.join(ALLOWED_DOMAINS))

    continue_or_not = input('[?] Tiếp tục tới bước kiểm tra email? (y/n): ')
    if continue_or_not.lower() != 'y':
        exit(2)

    your_email = input('[i] Nhập địa chỉ email: ')
    if validate_email(your_email):
        print('[i] Địa chỉ email hợp lệ.')
        exit(0)
    else:
        print('[!] Địa chỉ email không hợp lệ.')
        exit(1)
