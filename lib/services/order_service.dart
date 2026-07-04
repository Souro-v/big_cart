import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../utils/constants.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

    await orderRef.set(order.toMap());

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

  Future<void> addLoyaltyPoints(String userId, double amount) async {
    final points = (amount * 10).toInt();
    await _db
        .collection(AppConstants.usersCol)
        .doc(userId)
        .update({'points': FieldValue.increment(points)});
  }

  Future<List<CartItemModel>> _loadOrderItems(String orderId) async {
    final itemsSnap = await _db
        .collection(AppConstants.ordersCol)
        .doc(orderId)
        .collection('items')
        .get();

    return itemsSnap.docs.map((doc) {
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
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    final snap = await _db
        .collection(AppConstants.ordersCol)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    final orders = <OrderModel>[];
    for (final doc in snap.docs) {
      final order = OrderModel.fromMap(doc.data(), doc.id);
      final items = await _loadOrderItems(doc.id);
      orders.add(OrderModel(
        id: order.id,
        userId: order.userId,
        items: items,
        totalAmount: order.totalAmount,
        address: order.address,
        status: order.status,
        notes: order.notes,
        createdAt: order.createdAt,
      ));
    }
    return orders;
  }

  Future<OrderModel?> getOrder(String orderId) async {
    final doc = await _db.collection(AppConstants.ordersCol).doc(orderId).get();

    if (!doc.exists) return null;

    final order = OrderModel.fromMap(doc.data()!, doc.id);
    final items = await _loadOrderItems(orderId);

    return OrderModel(
      id: order.id,
      userId: order.userId,
      items: items,
      totalAmount: order.totalAmount,
      address: order.address,
      status: order.status,
      notes: order.notes,
      createdAt: order.createdAt,
    );
  }

  Stream<List<OrderModel>> getUserOrdersStream(String userId) {
    return _db
        .collection(AppConstants.ordersCol)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snap) async {
      final orders = <OrderModel>[];
      for (final doc in snap.docs) {
        final order = OrderModel.fromMap(doc.data(), doc.id);
        final items = await _loadOrderItems(doc.id);
        orders.add(OrderModel(
          id: order.id,
          userId: order.userId,
          items: items,
          totalAmount: order.totalAmount,
          address: order.address,
          status: order.status,
          notes: order.notes,
          createdAt: order.createdAt,
        ));
      }
      return orders;
    });
  }

  Future<void> cancelOrder(String orderId) async {
    await _db.collection(AppConstants.ordersCol).doc(orderId).update({
      'status': OrderStatus.cancelled.name,
    });
  }
}