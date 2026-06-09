import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/constants.dart';

class ActivityService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> log({
    required String userId,
    required String action,
    String? details,
  }) async {
    try {
      await _db
          .collection(AppConstants.usersCol)
          .doc(userId)
          .collection('activity')
          .add({
        'action': action,
        'details': details ?? '',
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Silent fail
    }
  }
}