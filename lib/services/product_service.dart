import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../utils/constants.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // সব products
  Future<List<ProductModel>> getAllProducts() async {
    final snap = await _db
        .collection(AppConstants.productsCol)
        .where('inStock', isEqualTo: true)
        .get();

    return snap.docs
        .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Category অনুযায়ী
  Future<List<ProductModel>> getByCategory(String category) async {
    final snap = await _db
        .collection(AppConstants.productsCol)
        .where('category', isEqualTo: category)
        .where('inStock', isEqualTo: true)
        .get();

    return snap.docs
        .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Search by name
  Future<List<ProductModel>> search(String query) async {
    final snap = await _db
        .collection(AppConstants.productsCol)
        .get();

    // Firestore-এ full text search নেই, তাই client-side filter
    final q = query.toLowerCase();
    return snap.docs
        .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();
  }

  // Single product
  Future<ProductModel?> getProduct(String id) async {
    final doc = await _db
        .collection(AppConstants.productsCol)
        .doc(id)
        .get();

    if (doc.exists) return ProductModel.fromMap(doc.data()!, doc.id);
    return null;
  }

  // সব categories (distinct)
  Future<List<String>> getCategories() async {
    final snap = await _db
        .collection(AppConstants.productsCol)
        .get();

    final categories = snap.docs
        .map((doc) => doc.data()['category'] as String)
        .toSet()
        .toList();

    return categories;
  }
}
