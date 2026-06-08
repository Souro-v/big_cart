import 'package:cloud_firestore/cloud_firestore.dart';

class FlashSaleService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getActiveFlashSales() async {
    final now = DateTime.now().toIso8601String();
    final snap = await _db
        .collection('flash_sales')
        .where('isActive', isEqualTo: true)
        .where('endTime', isGreaterThan: now)
        .get();

    return snap.docs.map((doc) => doc.data()).toList();
  }
}