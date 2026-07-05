class ProductModel {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final double discount;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.discount,
    required this.description,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? 'General',
      discount: (map['discount'] ?? 0).toDouble(),
      description: map['description'] ?? '',
    );
  }

  // 🔥 FINAL PRICE CALCULATION
  double get finalPrice {
    return price - (price * discount / 100);
  }
}