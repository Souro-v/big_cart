import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> placeOrder({
    required String userId,
    required List<CartItemModel> items,
    required double totalAmount,
    required String address,
  }) async {
    _isLoading = true; _error = null; notifyListeners();
    try {
      await _orderService.placeOrder(
        userId: userId,
        items: items,
        totalAmount: totalAmount,
        address: address,
      );
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  Future<void> loadOrders(String userId) async {
    _isLoading = true; notifyListeners();
    try {
      _orders = await _orderService.getUserOrders(userId);
    } finally {
      _isLoading = false; notifyListeners();
    }
  }
}