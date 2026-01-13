# 📱 Civic-Snap

Civic-Snap là một ứng dụng di động cho phép người dân báo cáo và theo dõi các vấn đề công cộng trong khu vực của họ, giúp cải thiện chất lượng dịch vụ công và tăng cường sự tương tác giữa người dân và chính quyền địa phương.

## 📋 Giới thiệu

Civic-Snap được xây dựng nhằm tạo ra một kênh giao tiếp hiệu quả giữa người dân và chính quyền địa phương. Ứng dụng cho phép người dùng dễ dàng báo cáo các vấn đề công cộng như:
- Hư hỏng cơ sở hạ tầng (đường sá, cầu, vỉa hè)
- Vấn đề về môi trường (rác thải, ô nhiễm)
- An ninh trật tự
- Và nhiều vấn đề khác liên quan đến đời sống công cộng

Với giao diện thân thiện và dễ sử dụng, người dân có thể nhanh chóng chụp ảnh, định vị vị trí và gửi báo cáo chỉ trong vài bước đơn giản.

## ✨ Các tính năng chính

### 1. 🔐 Xác thực người dùng
- Đăng ký/Đăng nhập tài khoản
- Xác thực qua Firebase Authentication
- Quản lý phiên đăng nhập an toàn với Flutter Secure Storage

### 2. 📝 Quản lý báo cáo
- Tạo báo cáo vấn đề công cộng với ảnh và mô tả chi tiết
- Tự động định vị GPS vị trí sự cố
- Phân loại báo cáo theo danh mục
- Theo dõi trạng thái xử lý của báo cáo
- Xem lịch sử các báo cáo đã gửi

### 3. 🗺️ Bản đồ tương tác
- Hiển thị các báo cáo trên bản đồ Google Maps
- Xem vị trí chi tiết của từng sự cố

### 4. 📊 Dashboard 
- Tổng quan về tình hình báo cáo
- Báo cáo theo khu vực địa lý

### 5. 👤 Quản lý người dùng
- Cập nhật thông tin cá nhân
- Quản lý hồ sơ người dùng
- Phân quyền người dùng (admin/user)

### 6. 🔔 Thông báo
- Nhận thông báo khi báo cáo được cập nhật
- Thông báo push về trạng thái xử lý
- Quản lý cài đặt thông báo

## 🛠️ Công nghệ được sử dụng

### Framework & Ngôn ngữ
- **Flutter** (SDK ^3.10.4) - Framework phát triển ứng dụng đa nền tảng
- **Dart** - Ngôn ngữ lập trình

### State Management & Dependency Injection
- **Provider** (^6.1.5) - Quản lý trạng thái ứng dụng
- **GetIt** (^9.2.0) - Dependency Injection và Service Locator
- **Equatable** (^2.0.8) - So sánh đối tượng

### Backend & Database
- **Firebase Core** (^4.3.0) - Nền tảng Firebase
- **Firebase Authentication** (^6.1.3) - Xác thực người dùng
- **Cloud Firestore** (^6.1.1) - Cơ sở dữ liệu NoSQL
- **Firebase Storage** (^13.0.5) - Lưu trữ file và hình ảnh
- **Firebase Messaging** (^16.1.0) - Push notifications

### Navigation & Routing
- **GoRouter** (^17.0.1) - Điều hướng và routing

### Maps & Location
- **Google Maps Flutter** (^2.14.0) - Tích hợp Google Maps
- **Geolocator** (^14.0.2) - Xác định vị trí GPS

### UI & UX
- **Google Fonts** (^7.0.0) - Font chữ tùy chỉnh
- **Cupertino Icons** (^1.0.8) - Icon iOS style

### Utilities
- **Image Picker** (^1.2.1) - Chọn ảnh từ thư viện/camera
- **Flutter Secure Storage** (^10.0.0) - Lưu trữ dữ liệu bảo mật
- **Flutter Local Notifications** (^19.5.0) - Thông báo local
- **Internet Connection Checker Plus** (^2.9.1) - Kiểm tra kết nối internet
- **FpDart** (^1.2.0) - Functional programming

### Developer Tools
- **Flutter Launcher Icons** (^0.14.4) - Tạo icon ứng dụng
- **Flutter Lints** (^6.0.0) - Code linting

## 🏗️ Kiến trúc dự án

Dự án được xây dựng theo kiến trúc **Clean Architecture** kết hợp với **Feature-First approach**, đảm bảo code dễ bảo trì, mở rộng và test.

### Các layer chính:

```
┌─────────────────────────────────────┐
│      Presentation Layer             │
│  (UI, Widgets, Providers)           │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│       Domain Layer                  │
│  (Entities, UseCases, Repositories) │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│        Data Layer                   │
│  (Models, Data Sources, Repos Impl) │
└─────────────────────────────────────┘
```

## 📁 Cấu trúc thư mục

```
lib/
├── core/                           # Core functionality
│   ├── common/                     # Shared components
│   ├── config/                     # App configuration
│   │   ├── routes/                 # Route definitions
│   │   └── theme/                  # Theme configuration
│   ├── error/                      # Error handling
│   ├── network/                    # Network services
│   ├── services/                   # Core services
│   └── utils/                      # Utility functions
│
├── features/                       # Feature modules
│   ├── authentication/             # Xác thực người dùng
│   │   ├── data/                   # Data layer
│   │   │   ├── datasources/        # API/Firebase datasources
│   │   │   ├── models/             # Data models
│   │   │   └── repositories/       # Repository implementations
│   │   ├── domain/                 # Domain layer
│   │   │   ├── entities/           # Business entities
│   │   │   ├── repositories/       # Repository interfaces
│   │   │   └── usecases/           # Business logic
│   │   └── presentation/           # Presentation layer
│   │       ├── pages/              # UI screens
│   │       ├── providers/          # State management
│   │       └── widgets/            # UI components
│   │
│   ├── report/                     # Quản lý báo cáo
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── map/                        # Tính năng bản đồ
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── dashboard/                  # Dashboard
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── user/                       # Quản lý người dùng
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── firebase_options.dart           # Firebase configuration
├── init_dependencies.dart          # Dependency injection setup
└── main.dart                       # App entry point

assets/
├── icons/                          # App icons
└── images/                         # Images and graphics

android/                            # Android specific code
ios/                               # iOS specific code
web/                               # Web specific code
linux/                             # Linux specific code
macos/                             # macOS specific code
windows/                           # Windows specific code
```

## 🚀 Cài đặt và chạy dự án

### Yêu cầu

- Flutter SDK ^3.10.4
- Dart SDK
- Android Studio / Xcode (để chạy trên mobile)
- Firebase project đã được cấu hình

### Các bước cài đặt

1. **Clone repository**
```bash
git clone <repository-url>
cd Civic-Snap/src
```

2. **Cài đặt dependencies**
```bash
flutter pub get
```

3. **Cấu hình Firebase**
- Tạo Firebase project tại [Firebase Console](https://console.firebase.google.com/)
- Thêm app Android/iOS vào project
- Download và thêm file `google-services.json` (Android) và `GoogleService-Info.plist` (iOS)
- Cấu hình Firebase Authentication, Firestore, Storage, và Messaging

4. **Chạy ứng dụng**
```bash
flutter run
```

## 🧪 Testing

```bash
flutter test
```

## 📱 Build ứng dụng

### Android
```bash
flutter build apk --release
```

## 📞 Liên hệ

- **Email**: tanlxag116@gmail.com
- **Phone**: 0918356643
- **Project Link**: [https://github.com/Tan-1106/University-QA-System](https://github.com/Tan-1106/University-QA-System)

---
