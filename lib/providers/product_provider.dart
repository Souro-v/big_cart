import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<ProductModel> _products = [];
  List<ProductModel> _searchResults = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;

  List<ProductModel> get products => _selectedCategory == 'All'
      ? _products
      : _products.where((p) => p.category == _selectedCategory).toList();
  List<ProductModel> get searchResults => _searchResults;
  List<String> get categories => ['All', ..._categories];
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true; notifyListeners();
    try {
      _products = await _productService.getAllProducts();
      _categories = await _productService.getCategories();
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) { _searchResults = []; notifyListeners(); return; }
    _searchResults = await _productService.search(query);
    notifyListeners();
  }
}