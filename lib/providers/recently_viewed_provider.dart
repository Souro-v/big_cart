import 'package:flutter/material.dart';
import '../models/product_model.dart';

class RecentlyViewedProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];
  static const int _maxItems = 10;

  List<ProductModel> get items => _items;
  bool get isEmpty => _items.isEmpty;

  void add(ProductModel product) {
    _items.removeWhere((p) => p.id == product.id);
    _items.insert(0, product);
    if (_items.length > _maxItems) {
      _items.removeLast();
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}