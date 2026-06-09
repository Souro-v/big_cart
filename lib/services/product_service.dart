import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../utils/constants.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const int _pageSize = 10;

  // Pagination use in products load
  Future<List<ProductModel>> getProducts({
    String? category,
    DocumentSnapshot? lastDoc,
  }) async {
    Query query = _db
        .collection(AppConstants.productsCol)
        .where('inStock', isEqualTo: true)
        .limit(_pageSize);

    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snap = await query.get();
    return snap.docs
        .map(
          (doc) =>
              ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  //  products
  Future<List<ProductModel>> getAllProducts() async {
    final snap = await _db
        .collection(AppConstants.productsCol)
        .where('inStock', isEqualTo: true)
        .get();

    return snap.docs
        .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
        .toList();
  }
  Future<List<String>> getSuggestions(String query) async {
    if (query.isEmpty) return [];
    final snap = await _db
        .collection(AppConstants.productsCol)
        .get();

    final q = query.toLowerCase();
    return snap.docs
        .map((doc) => doc.data()['name'] as String)
        .where((name) => name.toLowerCase().contains(q))
        .take(5)
        .toList();
  }

  // Category
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
    final snap = await _db.collection(AppConstants.productsCol).get();

    // Firestore full text search is of so client-side filter
    final q = query.toLowerCase();
    return snap.docs
        .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();
  }

  // Single product
  Future<ProductModel?> getProduct(String id) async {
    final doc = await _db.collection(AppConstants.productsCol).doc(id).get();

    if (doc.exists) return ProductModel.fromMap(doc.data()!, doc.id);
    return null;
  }

  //categories (distinct)
  Future<List<String>> getCategories() async {
    final snap = await _db.collection(AppConstants.productsCol).get();

    final categories = snap.docs
        .map((doc) => doc.data()['category'] as String)
        .toSet()
        .toList();

    return categories;
  }
}
