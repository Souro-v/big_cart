import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/crashlytics_service.dart';
import '../services/product_service.dart';

enum SortOption { none, priceLowHigh, priceHighLow, newest, discount }

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<ProductModel> _products = [];
  List<ProductModel> _searchResults = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  SortOption _sortOption = SortOption.none;
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  List<ProductModel> get searchResults => _searchResults;
  List<String> get categories => ['All', ..._categories];
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  SortOption get sortOption => _sortOption;

  List<ProductModel> get products {
    List<ProductModel> filtered = _selectedCategory == 'All'
        ? List.from(_products)
        : _products.where((p) => p.category == _selectedCategory).toList();

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

  Future<void> loadProducts() async {
    _isLoading = true; notifyListeners();
    try {
      _products = await _productService.getAllProducts();
      _categories = await _productService.getCategories();
    } catch (e, stack) {
      _products = [];
      await CrashlyticsService().logError(e, stack,
          reason: 'Failed to load products');
      debugPrint('Error: $e');
    } finally {
      _isLoading = false; notifyListeners();
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