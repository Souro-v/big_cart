import 'package:flutter/material.dart';
import '../models/product_model.dart';

class WishlistProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => _items;
  bool get isEmpty => _items.isEmpty;
  int get count => _items.length;

  bool isWishlisted(String productId) =>
      _items.any((p) => p.id == productId);

  void toggle(ProductModel product) {
    if (isWishlisted(product.id)) {
      _items.removeWhere((p) => p.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void remove(String productId) {
    _items.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}