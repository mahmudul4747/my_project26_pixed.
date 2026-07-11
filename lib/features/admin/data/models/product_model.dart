import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;

  final String name;

  final String description;

  final double price;

  final String imageUrl;

  final String category;

  final double discount;

  /// ⭐ NEW
  final double rating;

  /// ⭐ NEW
  final int stock;

  /// ⭐ NEW
  final bool isAvailable;

  /// ⭐ NEW
  final DateTime? createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.discount,

    this.description = '',
    this.rating = 4.5,
    this.stock = 0,
    this.isAvailable = true,
    this.createdAt,
  });

  /// Discount Price
  double get finalPrice {
    return price - (price * discount / 100);
  }

  factory ProductModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return ProductModel(
      id: id,

      name: map['name'] ?? '',

      description: map['description'] ?? '',

      price: (map['price'] ?? 0).toDouble(),

      imageUrl: map['imageUrl'] ?? '',

      category: map['category'] ?? 'General',

      discount: (map['discount'] ?? 0).toDouble(),

      rating: (map['rating'] ?? 4.5).toDouble(),

      stock: (map['stock'] ?? 0).toInt(),

      isAvailable: map['isAvailable'] ?? true,

      createdAt: map['createdAt'] == null
          ? null
          : (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,

      'description': description,

      'price': price,

      'imageUrl': imageUrl,

      'category': category,

      'discount': discount,

      'rating': rating,

      'stock': stock,

      'isAvailable': isAvailable,

      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    double? discount,
    double? rating,
    int? stock,
    bool? isAvailable,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      discount: discount ?? this.discount,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}