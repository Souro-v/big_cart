import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsService {
  // User set — login call
  Future<void> setUser(String userId, String email) async {
    if (kDebugMode) return;
    await FirebaseCrashlytics.instance.setUserIdentifier(userId);
    await FirebaseCrashlytics.instance.setCustomKey('email', email);
  }

  // User clear  — logout call
  Future<void> clearUser() async {
    if (kDebugMode) return;
    await FirebaseCrashlytics.instance.setUserIdentifier('');
  }

  // Non-fatal error log
  Future<void> logError(dynamic error, StackTrace? stack,
      {String? reason}) async {
    if (kDebugMode) return;
    await FirebaseCrashlytics.instance.recordError(
      error, stack,
      reason: reason,
      fatal: false,
    );
  }

  // Custom log
  Future<void> log(String message) async {
    if (kDebugMode) return;
    await FirebaseCrashlytics.instance.log(message);
  }
}