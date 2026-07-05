import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

enum SortOption { none, priceLowHigh, priceHighLow, newest, discount }

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<ProductModel> _products = [];
  List<ProductModel> _searchResults = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _isSearching = false;
  SortOption _sortOption = SortOption.none;
  double? _minPrice;
  double? _maxPrice;
  int? _minRating;
  DocumentSnapshot? _lastDoc;
  bool _hasDiscount = false;
  bool _freeShipping = false;

  List<ProductModel> get searchResults => _searchResults;

  List<String> get categories => ['All', ..._categories];

  String get selectedCategory => _selectedCategory;

  bool get isLoading => _isLoading;

  bool get isLoadingMore => _isLoadingMore;

  bool get hasMore => _hasMore;

  bool get isSearching => _isSearching;

  SortOption get sortOption => _sortOption;

  List<ProductModel> get products {
    List<ProductModel> filtered = _selectedCategory == 'All'
        ? List.from(_products)
        : _products.where((p) => p.category == _selectedCategory).toList();

    // Price filter
    if (_minPrice != null) {
      filtered = filtered.where((p) => p.price >= _minPrice!).toList();
    }
    if (_maxPrice != null) {
      filtered = filtered.where((p) => p.price <= _maxPrice!).toList();
    }

    // Rating filter
    if (_minRating != null) {
      filtered = filtered.where((p) => p.rating >= _minRating!).toList();
    }
    //discount
    if (_hasDiscount) {
      filtered = filtered.where((p) => p.discount > 0).toList();
    }
    //free shipping
    if (_freeShipping) {
      filtered = filtered.where((p) => p.stockCount > 0).toList();
    }
    // Sort
    switch (_sortOption) {
      case SortOption.priceLowHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.newest:
        filtered = [
          ...filtered.where((p) => p.isNew),
          ...filtered.where((p) => !p.isNew),
        ];
        break;
      case SortOption.discount:
        filtered.sort((a, b) => b.discount.compareTo(a.discount));
        break;
      case SortOption.none:
        break;
    }
    return filtered;
  }

  // First page load
  Future<void> loadProducts() async {
    _isLoading = true;
    _products = [];
    _lastDoc = null;
    _hasMore = true;
    notifyListeners();

    try {
      final snap = await FirebaseFirestore.instance
          .collection('products')
          .where('inStock', isEqualTo: true)
          .limit(10)
          .get();

      _products = snap.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();

      if (snap.docs.isNotEmpty) {
        _lastDoc = snap.docs.last;
      }

      _hasMore = snap.docs.length == 10;
      _categories = await _productService.getCategories();
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load more — pagination
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _lastDoc == null) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final snap = await FirebaseFirestore.instance
          .collection('products')
          .where('inStock', isEqualTo: true)
          .startAfterDocument(_lastDoc!)
          .limit(10)
          .get();

      final newProducts = snap.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();

      _products.addAll(newProducts);

      if (snap.docs.isNotEmpty) {
        _lastDoc = snap.docs.last;
      }

      _hasMore = snap.docs.length == 10;
    } catch (e) {
      debugPrint('Error loading more: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void sortBy(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void clearSort() {
    _sortOption = SortOption.none;
    notifyListeners();
  }

  void applyFilter({
    double? minPrice,
    double? maxPrice,
    int? minRating,
    bool hasDiscount = false,
    bool freeShipping = false,
  }) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _minRating = minRating;
    _hasDiscount = hasDiscount;
    _freeShipping = freeShipping;
    notifyListeners();
  }

  void clearFilter() {
    _minPrice = null;
    _maxPrice = null;
    _minRating = null;
    _hasDiscount = false;
    _freeShipping = false;
    notifyListeners();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    _isSearching = true;
    notifyListeners();
    try {
      _searchResults = await _productService.search(query);
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  List<ProductModel> getRelated(String category, String excludeId) {
    return _products
        .where((p) => p.category == category && p.id != excludeId)
        .take(6)
        .toList();
  }
}
