# Flutter Week 4 Exercise

Project Flutter hoàn chỉnh cho bài tập Week 4 gồm: ListView, GridView, SharedPreferences, Async Programming & Isolate.

## Cấu trúc Project

```
flutter_week4_exercise/
├── pubspec.yaml                        # Dependencies
├── lib/
│   ├── main.dart                       # Entry point
│   ├── screens/
│   │   ├── home_screen.dart            # Màn hình chính - menu điều hướng
│   │   ├── list_view_screen.dart       # Exercise 1: ListView
│   │   ├── grid_view_screen.dart       # Exercise 2: GridView
│   │   ├── shared_prefs_screen.dart    # Exercise 3: SharedPreferences
│   │   ├── async_screen.dart           # Exercise 4: Async/Await
│   │   └── isolate_screen.dart         # Exercise 5: Isolate
│   ├── widgets/
│   │   ├── contact_item.dart           # Widget contact cho ListView
│   │   └── grid_item.dart              # Widget item cho GridView
│   └── services/
│       ├── shared_prefs_service.dart   # Service xử lý SharedPreferences
│       └── isolate_service.dart        # Service xử lý Isolate
└── README.md
```

## Cài đặt & Chạy Project

### Bước 1: Cài đặt Flutter SDK
- Download Flutter tại: https://flutter.dev/docs/get-started/install
- Thêm flutter/bin vào PATH
- Chạy `flutter doctor` để kiểm tra

### Bước 2: Mở project trong Android Studio
1. Mở Android Studio
2. File → Open → Chọn thư mục `flutter_week4_exercise`
3. Chờ Android Studio index project

### Bước 3: Cài Dependencies
Mở Terminal trong Android Studio (View → Tool Windows → Terminal) và chạy:
```bash
flutter pub get
```

### Bước 4: Chạy ứng dụng
Cách 1 - Dùng Android Studio:
- Chọn device (emulator hoặc physical device) ở thanh toolbar
- Nhấn nút Run hoặc Shift+F10

Cách 2 - Dùng Terminal:
```bash
flutter run
```

## 📱 Hướng dẫn test từng chức năng

### Exercise 1 - List View
1. Nhấn "Exercise 1 - List View" từ màn hình chính
2. Danh sách 15 contacts hiện ra, cuộn lên xuống để test scroll
3. Gõ vào thanh tìm kiếm để lọc theo tên/phone/department
4. Nhấn vào một contact để xem chi tiết

### Exercise 2 - Grid View
1. Nhấn "Exercise 2 - Grid View" từ màn hình chính
2. Fixed Column Grid (GridView.count): 3 cột, aspect ratio 1:1
3. Responsive Grid (GridView.extent): ô rộng tối đa 150px, aspect ratio 0.8
4. Cuộn xuống để xem cả 2 loại grid

### Exercise 3 - Shared Preferences
1. Nhấn "Exercise 3 - Shared Preferences"
2. Nhập tên vào TextField (bắt buộc)
3. Nhập tuổi, email (tùy chọn - Bonus)
4. Nhấn "Save Name" → dữ liệu được lưu
5. Nhấn "Show" → tải và hiển thị dữ liệu đã lưu
6. Xem timestamp lần lưu cuối (Bonus)
7. Nhấn "Clear" → xóa tất cả dữ liệu (Bonus)
8. Tắt app, mở lại → dữ liệu vẫn còn (do SharedPreferences persistent)

### Exercise 4 - Async Programming
1. Nhấn "Exercise 4 - Async Programming"
2. Nhấn nút "Load User"
3. Màn hình hiển thị "Loading user..." với animation
4. Sau 3 giây → hiển thị "User loaded successfully!"
5. Xem Console Log để theo dõi từng bước
6. Thử nhấn Load User nhiều lần

### Exercise 5 - Isolate
Task 1 - Factorial:
1. Chọn tab "Task 1: Factorial"
2. Chọn giá trị n (thử với 30000)
3. Nhấn "Tính 30000!"
4. Thấy loading indicator - thử cuộn màn hình → UI vẫn mượt (không bị freeze)
5. Sau vài giây → hiển thị kết quả (số chữ số, chữ số đầu/cuối, thời gian)

Task 2 - Random Sum:
1. Chọn tab "Task 2: Random Sum"
2. Nhấn "Start" → spawn worker isolate
3. Mỗi giây worker gửi 1 số random (1-30)
4. Progress bar tăng dần theo tổng
5. Khi tổng > 100 → tự động gửi STOP → worker exit
6. Nhấn "Reset" để chạy lại

## Dependencies

```yaml
shared_preferences: ^2.2.2   # Lưu dữ liệu cục bộ
intl: ^0.19.0                # Định dạng ngày giờ
```

## Các khái niệm Flutter được sử dụng

Khái niệm | Được dùng ở
- `ListView.builder` | list_view_screen.dart 
- `GridView.count` | grid_view_screen.dart 
- `GridView.extent` | grid_view_screen.dart 
- `SharedPreferences` | shared_prefs_service.dart 
- `Future / async / await` | async_screen.dart 
- `compute()` | isolate_service.dart 
- `Isolate.spawn()` | isolate_service.dart 
- `SendPort / ReceivePort` | isolate_service.dart 
- `Isolate.exit()` | isolate_service.dart 
- `StatefulWidget` | Tất cả màn hình có state 
- `Stream` | isolate_screen.dart (Tab 2)

## Lưu ý

- Android Studio hoặc VS Code đều chạy được
- Flutter SDK 3.0.0+ (Dart 3)
- Test trên emulator API 24+ hoặc physical device Android 7+
- Chạy `flutter clean` rồi `flutter pub get` nếu có lỗi
