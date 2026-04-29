// ============================================================
// FILE: lib/services/shared_prefs_service.dart
// CHỨC NĂNG: Service xử lý tất cả thao tác với SharedPreferences
// ============================================================

import 'package:shared_preferences/shared_preferences.dart';

/// Service class tập trung xử lý SharedPreferences
/// Áp dụng pattern Service Layer để tách logic ra khỏi UI
class SharedPrefsService {
  // Keys để lưu trữ - dùng constant tránh typo
  static const String _keyName = 'user_name';
  static const String _keyAge = 'user_age';
  static const String _keyEmail = 'user_email';
  static const String _keyTimestamp = 'last_saved_timestamp';

  /// Lấy instance SharedPreferences (dùng caching nội bộ của thư viện)
  static Future<SharedPreferences> _getInstance() async {
    return await SharedPreferences.getInstance();
  }

  // ========================================
  // LƯU DỮ LIỆU
  // ========================================

  /// Lưu thông tin người dùng vào SharedPreferences
  /// Tự động lưu timestamp hiện tại
  static Future<bool> saveUserData({
    required String name,
    String? age,
    String? email,
  }) async {
    try {
      final prefs = await _getInstance();

      // Lưu từng field
      await prefs.setString(_keyName, name);
      if (age != null && age.isNotEmpty) {
        await prefs.setString(_keyAge, age);
      }
      if (email != null && email.isNotEmpty) {
        await prefs.setString(_keyEmail, email);
      }

      // Lưu timestamp theo định dạng ISO 8601
      final timestamp = DateTime.now().toIso8601String();
      await prefs.setString(_keyTimestamp, timestamp);

      return true;
    } catch (e) {
      // Trả về false nếu có lỗi
      return false;
    }
  }

  // ========================================
  // ĐỌC DỮ LIỆU
  // ========================================

  /// Đọc tên đã lưu (trả về null nếu chưa có)
  static Future<String?> getName() async {
    final prefs = await _getInstance();
    return prefs.getString(_keyName);
  }

  /// Đọc tuổi đã lưu
  static Future<String?> getAge() async {
    final prefs = await _getInstance();
    return prefs.getString(_keyAge);
  }

  /// Đọc email đã lưu
  static Future<String?> getEmail() async {
    final prefs = await _getInstance();
    return prefs.getString(_keyEmail);
  }

  /// Đọc timestamp lần lưu cuối
  static Future<String?> getTimestamp() async {
    final prefs = await _getInstance();
    return prefs.getString(_keyTimestamp);
  }

  /// Đọc tất cả dữ liệu người dùng trong một lần gọi
  static Future<Map<String, String?>> getAllUserData() async {
    final prefs = await _getInstance();
    await prefs.reload(); // Đảm bảo dữ liệu mới nhất từ disk
    return {
      'name': prefs.getString(_keyName),
      'age': prefs.getString(_keyAge),
      'email': prefs.getString(_keyEmail),
      'timestamp': prefs.getString(_keyTimestamp),
    };
  }

  // ========================================
  // XÓA DỮ LIỆU
  // ========================================

  /// Xóa tất cả dữ liệu đã lưu
  static Future<bool> clearAllData() async {
    try {
      final prefs = await _getInstance();
      await prefs.remove(_keyName);
      await prefs.remove(_keyAge);
      await prefs.remove(_keyEmail);
      await prefs.remove(_keyTimestamp);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Kiểm tra xem đã có dữ liệu nào được lưu chưa
  static Future<bool> hasData() async {
    final prefs = await _getInstance();
    return prefs.containsKey(_keyName);
  }
}
