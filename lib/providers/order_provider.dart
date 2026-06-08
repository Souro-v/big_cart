import 'dart:async';
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../services/crashlytics_service.dart';
import '../services/order_service.dart';
import '../utils/error_handler.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _subscription;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> placeOrder({
    required String userId,
    required List<CartItemModel> items,
    required double totalAmount,
    required String address,
     required String notes,
  }) async {
    _isLoading = true; _error = null; notifyListeners();
    try {
      await _orderService.placeOrder(
        userId: userId,
        items: items,
        totalAmount: totalAmount,
        address: address,
        notes: notes,
      );
      await CrashlyticsService().log('Order placed successfully');
      return true;
    } catch (e , stack) {
      _error = ErrorHandler.getMessage(e);
      await CrashlyticsService().logError(e, stack,
          reason: 'Failed to place order');
      return false;
    } finally {
      _isLoading = false; notifyListeners();
    }
  }
  Future<bool> cancelOrder(String orderId) async {
    try {
      await _orderService.cancelOrder(orderId);
      return true;
    } catch (e) {
      _error = ErrorHandler.getMessage(e);
      notifyListeners();
      return false;
    }
  }

  // Real-time orders listen
  void listenToOrders(String userId) {
    _isLoading = true; notifyListeners();

    _subscription?.cancel();
    _subscription = _orderService
        .getUserOrdersStream(userId)
        .listen(
          (orders) {
        _orders = orders;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Old method — still works
  Future<void> loadOrders(String userId) async {
    _isLoading = true; notifyListeners();
    try {
      _orders = await _orderService.getUserOrders(userId);
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}