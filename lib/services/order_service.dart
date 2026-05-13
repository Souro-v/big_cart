import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../utils/constants.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Order place করো
  Future<String> placeOrder({
    required String userId,
    required List<CartItemModel> items,
    required double totalAmount,
    required String address,
  }) async {
    final orderRef = _db.collection(AppConstants.ordersCol).doc();

    final order = OrderModel(
      id: orderRef.id,
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      address: address,
      createdAt: DateTime.now(),
    );

    // Order save
    await orderRef.set(order.toMap());

    // Items আলাদা subcollection-এ
    for (final item in items) {
      await orderRef.collection('items').add({
        'productId': item.product.id,
        'productName': item.product.name,
        'imageUrl': item.product.imageUrl,
        'price': item.product.price,
        'quantity': item.quantity,
        'totalPrice': item.totalPrice,
      });
    }

    return orderRef.id;
  }

  // User-এর সব orders
  Future<List<OrderModel>> getUserOrders(String userId) async {
    final snap = await _db
        .collection(AppConstants.ordersCol)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs
        .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Single order detail
  Future<OrderModel?> getOrder(String orderId) async {
    final doc = await _db
        .collection(AppConstants.ordersCol)
        .doc(orderId)
        .get();

    if (doc.exists) return OrderModel.fromMap(doc.data()!, doc.id);
    return null;
  }
}
