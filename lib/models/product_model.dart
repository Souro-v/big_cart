class ProductModel {
  final String id;
  final String name;
  final String imageUrl;  // Cloudinary URL
  final String category;
  final String unit;      // "1 kg", "500 ml" etc
  final double price;
  final String description;
  final bool inStock;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.unit,
    required this.price,
    this.description = '',
    this.inStock = true,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      unit: map['unit'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      inStock: map['inStock'] ?? true,
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
    };
  }
}
