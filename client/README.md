# Projetc Structure
NextFlit/
├── android/                   # Mã nguồn riêng cho Android
├── build/                     # Các tệp được tạo ra khi build
├── ios/                       # Mã nguồn riêng cho iOS
├── lib/                       # Mã nguồn Flutter/Dart
│   ├── blocs/                 # Chứa các BLoC (business logic components)
│   │   ├── authentication_bloc.dart # Ví dụ về một BLoC
│   │   └── ...                # Các tệp BLoC khác
│   ├── models/                # Các mô hình dữ liệu (ví dụ: user, product)
│   ├── repositories/          # Chứa logic kinh doanh (ví dụ: gọi API, quản lý dữ liệu)
│   │   └── user_repository.dart  # Repository xử lý dữ liệu người dùng
│   ├── screens/               # Các màn hình UI (Widgets đại diện cho các trang)
│   │   ├── login_screen.dart  # Màn hình đăng nhập
│   │   └── home_screen.dart  # Màn hình chính
│   ├── widgets/               # Các Widget tái sử dụng
│   ├── services/              # Dịch vụ API hoặc nguồn dữ liệu
│   ├── utils/                 # Các hàm tiện ích
│   ├── constants/                 # Chứa các constant dùng chung
│   │   ├── app_constants.dart     # Các hằng số chung cho toàn app
│   │   ├── api_endpoints.dart     # Định nghĩa các endpoint API
│   │   ├── colors.dart            # Các mã màu dùng chung
│   │   └── strings.dart           # Các chuỗi văn bản tĩnh
│   └── main.dart              # Điểm vào chính của ứng dụng
├── test/                      # Các bài kiểm tra đơn vị và widget
│   └── blocs/                 # Kiểm tra các BLoC
├── pubspec.yaml               # Cấu hình và các phụ thuộc của dự án
└── README.md                  # Tài liệu mô tả dự án
