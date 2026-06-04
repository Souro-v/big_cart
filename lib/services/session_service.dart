import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _lastActiveKey = 'last_active';
  static const int _timeoutMinutes = 30;

  // Last active time save
  Future<void> updateLastActive() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _lastActiveKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  // Session expired check
  Future<bool> isSessionExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final lastActive = prefs.getInt(_lastActiveKey);
    if (lastActive == null) return false;

    final lastActiveTime =
    DateTime.fromMillisecondsSinceEpoch(lastActive);
    final difference = DateTime.now().difference(lastActiveTime);
    return difference.inMinutes >= _timeoutMinutes;
  }

  // Session clear
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastActiveKey);
  }
}