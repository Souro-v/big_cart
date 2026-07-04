import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _userId;

  List<CartItemModel> get items => _items;
  int get itemCount => _items.length;
  bool get isEmpty => _items.isEmpty;
  double get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);

  static const int maxQty = 10;

  Future<void> loadCart(String userId) async {
    _userId = userId;
    try {
      final snap = await _db
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      _items.clear();
      for (final doc in snap.docs) {
        final data = doc.data();
        _items.add(CartItemModel(
          product: ProductModel(
            id: doc.id,
            name: data['name'] ?? '',
            imageUrl: data['imageUrl'] ?? '',
            category: data['category'] ?? '',
            unit: data['unit'] ?? '',
            price: (data['price'] ?? 0).toDouble(),
            description: data['description'] ?? '',
            inStock: data['inStock'] ?? true,
            isNew: data['isNew'] ?? false,
            discount: data['discount'] ?? 0,
          ),
          quantity: data['quantity'] ?? 1,
        ));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  Future<void> _saveCartItem(CartItemModel item) async {
    if (_userId == null) return;
    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc(item.product.id)
          .set({
        'name': item.product.name,
        'imageUrl': item.product.imageUrl,
        'category': item.product.category,
        'unit': item.product.unit,
        'price': item.product.price,
        'description': item.product.description,
        'inStock': item.product.inStock,
        'isNew': item.product.isNew,
        'discount': item.product.discount,
        'quantity': item.quantity,
      });
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  Future<void> _deleteCartItem(String productId) async {
    if (_userId == null) return;
    try {
      await _db
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc(productId)
          .delete();
    } catch (e) {
      debugPrint('Error deleting cart item: $e');
    }
  }

  void addToCart(ProductModel product) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      if (_items[index].quantity < maxQty) {
        _items[index].quantity++;
        _saveCartItem(_items[index]);
      }
    } else {
      final newItem = CartItemModel(product: product);
      _items.add(newItem);
      _saveCartItem(newItem);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    _deleteCartItem(productId);
    notifyListeners();
  }

  void increaseQty(String productId) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index >= 0 && _items[index].quantity < maxQty) {
      _items[index].quantity++;
      _saveCartItem(_items[index]);
      notifyListeners();
    }
  }

  void decreaseQty(String productId) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        _saveCartItem(_items[index]);
      } else {
        _items.removeAt(index);
        _deleteCartItem(productId);
      }
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    if (_userId != null) {
      try {
        final snap = await _db
            .collection('users')
            .doc(_userId)
            .collection('cart')
            .get();
        for (final doc in snap.docs) {
          await doc.reference.delete();
        }
      } catch (e) {
        debugPrint('Error clearing Firestore cart: $e');
      }
    }
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String productId) => _items.any((i) => i.product.id == productId);

  void clearLocal() {
    _items.clear();
    _userId = null;
    notifyListeners();
  }
}