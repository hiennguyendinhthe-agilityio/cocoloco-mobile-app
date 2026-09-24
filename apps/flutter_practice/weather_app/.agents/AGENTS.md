# AGENTS.md - Weather App Rules

## 🎯 Verification Rules
- **Kiểm tra lỗi trước khi hoàn thành**: Trước khi báo cáo hoàn thành một task, AI **bắt buộc** phải chạy `dart analyze` và `flutter test` (nếu cần) để đảm bảo không có lỗi (error) do syntax, broken imports, hay unresolved references gây ra.
- Nếu có bất kỳ lỗi nào, AI phải tự fix xong toàn bộ mới được phép thông báo hoàn thành task.

## 🏗️ Clean Architecture Rules
- **Pure Dart Domain**: Tầng `domain` KHÔNG được chứa bất kỳ import nào liên quan đến UI hay State Management (như `flutter/material.dart`, `riverpod`, v.v.). Tầng này chỉ chứa pure Dart logic và Interfaces.
- **Strict Dependency Rule**: Luồng phụ thuộc luôn hướng vào trong (Data / Presentation -> Domain). `Presentation` (Providers/Notifiers/UI) chỉ được phép giao tiếp với `Domain` thông qua `UseCases`, **TUYỆT ĐỐI KHÔNG** được gọi trực tiếp `Repositories` hoặc `Data Sources`.

## 🛠️ State Management (Riverpod) Rules
- **Riverpod 3.0 Standard**: Khuyến khích sử dụng `AsyncNotifier` / `Notifier` (và file code generation nếu có thể) thay cho `StateNotifier` cũ. Các state nên tận dụng triệt để `AsyncValue`.
- **Centralized Dependency Injection**: Tất cả các Provider chuyên dùng để cung cấp instance (UseCase, Repository, API Client...) phải được khai báo tập trung (ví dụ trong file `di_providers.dart`). Không để rải rác cùng file với logic implementation.

## 🧪 Testing & Code Quality
- **Cập nhật Mocks (Mocktail)**: Project đang sử dụng Mocktail theo cách khai báo thủ công. Khi AI thay đổi signature của bất kỳ Interface nào (đặc biệt ở Domain), AI **phải tự động** vào thư mục `test/` (cụ thể là `repository.mocks.dart` hoặc `service.mocks.dart`) để update lại hoặc báo người dùng update.
- **Mindset Mentor (Why over How)**: Khi viết code mới hoặc refactor kiến trúc, AI phải luôn đóng vai trò là một Senior Developer, đưa ra giải thích rõ ràng "Tại sao làm như thế này lại tốt hơn theo nguyên lý SOLID/Clean Architecture" thay vì chỉ im lặng viết code.
