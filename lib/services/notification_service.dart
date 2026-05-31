import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Permission request
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // FCM Token
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Foreground message: ${message.notification?.title}');
    });

    // Background message handler
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('App opened from notification: ${message.notification?.title}');
    });
  }

  // Order status notification save  Firestore
  Future<void> saveToken(String userId) async {
    final token = await _messaging.getToken();
    if (token != null) {
      // Firestore user token save
      debugPrint('Saving token for user: $userId');
    }
  }
}