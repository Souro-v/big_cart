import 'package:big_cart/utils/constants.dart';

class ProductModel {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String unit;
  final double price;
  final String description;
  final bool inStock;
  final bool isNew;
  final int discount;
  final double rating;
  final int reviewCount;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.unit,
    required this.price,
    this.description = '',
    this.inStock = true,
    this.isNew = false,
    this.discount = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      imageUrl: AppConstants.imageUrl(map['imageUrl'] ?? ''),
      category: map['category'] ?? '',
      unit: map['unit'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      inStock: map['inStock'] ?? true,
      isNew: map['isNew'] ?? false,
      discount: map['discount'] ?? 0,
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'category': category,
      'unit': unit,
      'price': price,
      'description': description,
      'inStock': inStock,
      'isNew': isNew,
      'discount': discount,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}