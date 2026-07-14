import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;

  final double price;
  final double discount;

  final int stock;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.discount,
    required this.stock,
    this.createdAt,
    this.updatedAt,
  });

  double get finalPrice =>
      price - (price * discount / 100);

  factory ProductModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return ProductModel(
      id: id,
      name: map["name"] ?? "",
      description: map["description"] ?? "",
      category: map["category"] ?? "",
      imageUrl: map["imageUrl"] ?? "",
      price: (map["price"] ?? 0).toDouble(),
      discount: (map["discount"] ?? 0).toDouble(),
      stock: (map["stock"] ?? 0) as int,
      createdAt: map["createdAt"] is Timestamp
          ? (map["createdAt"] as Timestamp).toDate()
          : null,
      updatedAt: map["updatedAt"] is Timestamp
          ? (map["updatedAt"] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "category": category,
      "imageUrl": imageUrl,
      "price": price,
      "discount": discount,
      "stock": stock,
      "createdAt": createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
      "updatedAt": FieldValue.serverTimestamp(),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? imageUrl,
    double? price,
    double? discount,
    int? stock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}