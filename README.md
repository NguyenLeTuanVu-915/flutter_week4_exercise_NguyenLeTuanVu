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
## Screenshots

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/cf1e62f2-ba90-42ba-a730-8a907bedf0bd" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b96353b8-e314-4e51-be60-d6d98ee0d2fd" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/2cbbeaad-b508-420c-8067-1fc512ca848e" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/faabe4a9-ed52-4f43-8fff-0f599e06fd7a" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b4448c84-8f08-4d85-8c91-72e07a9c8e88" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/e66bd0b2-6325-4110-b728-4288a8f663ad" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/0c4c64e7-f9d0-4979-b548-258ff35e0089" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/cc61d3f7-844f-471d-bc92-177065ae556d" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/0a1b0e33-1a57-4177-a3d0-e36c50f19ec6" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/81c00397-a955-417d-8532-a4d14a61f9bc" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/21e7d41c-9c15-4291-8b41-8a1d7a44032e" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/2b9564f3-d7d2-48c5-a9f0-751d4cdd8931" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/84f584cb-3fae-4aef-bec7-9d1104cc2f32" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/2ebe377d-1ff3-4f29-9933-dd2c4d89f640" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/d0015994-ae15-40f8-9be2-ed4c508d1107" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/8a9fe3b6-98a0-49c4-b4d5-9152fc196c12" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/733e75f3-9777-442e-8787-95e9b6e2f4ce" />

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
