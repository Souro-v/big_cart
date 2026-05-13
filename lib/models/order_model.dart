import 'cart_item_model.dart';

enum OrderStatus { pending, confirmed, delivered, cancelled }

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final String address;
  final OrderStatus status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.address,
    this.status = OrderStatus.pending,
    required this.createdAt,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.pending:   return 'Pending';
      case OrderStatus.confirmed: return 'Confirmed';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      items: [],  // Firestore থেকে আলাদা parse হবে
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      address: map['address'] ?? '',
      status: OrderStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalAmount': totalAmount,
      'address': address,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
