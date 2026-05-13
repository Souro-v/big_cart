import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;
  int get itemCount => _items.length;
  bool get isEmpty => _items.isEmpty;

  double get totalAmount =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addToCart(ProductModel product) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItemModel(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  void increaseQty(String productId) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index >= 0) { _items[index].quantity++; notifyListeners(); }
  }

  void decreaseQty(String productId) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String productId) =>
      _items.any((i) => i.product.id == productId);
}