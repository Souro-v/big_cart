import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../utils/constants.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Order place
  Future<String> placeOrder({
    required String userId,
    required List<CartItemModel> items,
    required double totalAmount,
    required String address,
    String notes = '',
  }) async {
    final orderRef = _db.collection(AppConstants.ordersCol).doc();

    final order = OrderModel(
      id: orderRef.id,
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      address: address,
      createdAt: DateTime.now(),
      notes: notes,
    );

    // Order save
    await orderRef.set(order.toMap());

    // Items  subcollection
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
  //loyalty points
  Future<void> addLoyaltyPoints(
      String userId, double amount) async {
    // $1 spend এ 10 points
    final points = (amount * 10).toInt();
    await _db
        .collection(AppConstants.usersCol)
        .doc(userId)
        .update({'points': FieldValue.increment(points)});
  }

  // User- orders
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
    final doc = await _db.collection(AppConstants.ordersCol).doc(orderId).get();

    if (!doc.exists) return null;

    final order = OrderModel.fromMap(doc.data()!, doc.id);

    // Items subcollection load
    final itemsSnap = await _db
        .collection(AppConstants.ordersCol)
        .doc(orderId)
        .collection('items')
        .get();

    // Items parse
    final items = itemsSnap.docs.map((doc) {
      final data = doc.data();
      return CartItemModel(
        product: ProductModel(
          id: data['productId'] ?? '',
          name: data['productName'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          category: '',
          unit: '',
          price: (data['price'] ?? 0).toDouble(),
        ),
        quantity: data['quantity'] ?? 1,
      );
    }).toList();

    return OrderModel(
      id: order.id,
      userId: order.userId,
      items: items,
      totalAmount: order.totalAmount,
      address: order.address,
      status: order.status,
      createdAt: order.createdAt,
    );
  }

  // User orders real-time stream
  Stream<List<OrderModel>> getUserOrdersStream(String userId) {
    return _db
        .collection(AppConstants.ordersCol)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> cancelOrder(String orderId) async {
    await _db.collection(AppConstants.ordersCol).doc(orderId).update({
      'status': OrderStatus.cancelled.name,
    });
  }
}
