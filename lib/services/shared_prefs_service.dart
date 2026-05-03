import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _keyName = 'user_name';
  static const String _keyAge = 'user_age';
  static const String _keyEmail = 'user_email';
  static const String _keyTimestamp = 'last_saved_timestamp';
  static Future<SharedPreferences> _getInstance() async {
    return await SharedPreferences.getInstance();
  }

  static Future<bool> saveUserData({
    required String name,
    String? age,
    String? email,
  }) async {
    try {
      final prefs = await _getInstance();

      await prefs.setString(_keyName, name);
      if (age != null && age.isNotEmpty) {
        await prefs.setString(_keyAge, age);
      }
      if (email != null && email.isNotEmpty) {
        await prefs.setString(_keyEmail, email);
      }

      final timestamp = DateTime.now().toIso8601String();
      await prefs.setString(_keyTimestamp, timestamp);

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> getName() async {
    final prefs = await _getInstance();
    return prefs.getString(_keyName);
  }

  static Future<String?> getAge() async {
    final prefs = await _getInstance();
    return prefs.getString(_keyAge);
  }

  static Future<String?> getEmail() async {
    final prefs = await _getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<String?> getTimestamp() async {
    final prefs = await _getInstance();
    return prefs.getString(_keyTimestamp);
  }

  static Future<Map<String, String?>> getAllUserData() async {
    final prefs = await _getInstance();
    await prefs.reload();
    return {
      'name': prefs.getString(_keyName),
      'age': prefs.getString(_keyAge),
      'email': prefs.getString(_keyEmail),
      'timestamp': prefs.getString(_keyTimestamp),
    };
  }

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

  static Future<bool> hasData() async {
    final prefs = await _getInstance();
    return prefs.containsKey(_keyName);
  }
}
