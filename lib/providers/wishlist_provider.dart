import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../utils/constants.dart';

class WishlistProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final List<ProductModel> _items = [];
  String? _userId;

  List<ProductModel> get items => _items;
  bool get isEmpty => _items.isEmpty;
  int get count => _items.length;

  bool isWishlisted(String productId) =>
      _items.any((p) => p.id == productId);

  // User login  wishlist load
  Future<void> loadWishlist(String userId) async {
    _userId = userId;
    try {
      final snap = await _db
          .collection(AppConstants.usersCol)
          .doc(userId)
          .collection('wishlist')
          .get();

      _items.clear();
      for (final doc in snap.docs) {
        final data = doc.data();
        _items.add(ProductModel(
          id: doc.id,
          name: data['name'] ?? '',
          imageUrl: AppConstants.imageUrl(data['imageUrl'] ?? ''),
          category: data['category'] ?? '',
          unit: data['unit'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          description: data['description'] ?? '',
          inStock: data['inStock'] ?? true,
          isNew: data['isNew'] ?? false,
          discount: data['discount'] ?? 0,
        ));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading wishlist: $e');
    }
  }

  Future<void> toggle(ProductModel product) async {
    if (isWishlisted(product.id)) {
      await _remove(product.id);
    } else {
      await _add(product);
    }
  }

  Future<void> _add(ProductModel product) async {
    _items.add(product);
    notifyListeners();

    if (_userId == null) return;
    try {
      await _db
          .collection(AppConstants.usersCol)
          .doc(_userId)
          .collection('wishlist')
          .doc(product.id)
          .set({
        'name': product.name,
        'imageUrl': product.imageUrl,
        'category': product.category,
        'unit': product.unit,
        'price': product.price,
        'description': product.description,
        'inStock': product.inStock,
        'isNew': product.isNew,
        'discount': product.discount,
      });
    } catch (e) {
      debugPrint('Error adding to wishlist: $e');
    }
  }

  Future<void> _remove(String productId) async {
    _items.removeWhere((p) => p.id == productId);
    notifyListeners();

    if (_userId == null) return;
    try {
      await _db
          .collection(AppConstants.usersCol)
          .doc(_userId)
          .collection('wishlist')
          .doc(productId)
          .delete();
    } catch (e) {
      debugPrint('Error removing from wishlist: $e');
    }
  }

  Future<void> remove(String productId) async {
    await _remove(productId);
  }

  void clearLocal() {
    _items.clear();
    _userId = null;
    notifyListeners();
  }
}