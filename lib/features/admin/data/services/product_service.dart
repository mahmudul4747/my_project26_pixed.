import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class ProductService {
  ProductService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  /// ==========================
  /// Add Product
  /// ==========================
  Future<void> addProduct(ProductModel product) async {
    await _products.add(product.toMap());
  }

  /// ==========================
  /// Update Product
  /// ==========================
  Future<void> updateProduct(ProductModel product) async {
    await _products.doc(product.id).update(
          product.toMap(),
        );
  }

  /// ==========================
  /// Delete Product
  /// ==========================
  Future<void> deleteProduct(
    String productId,
  ) async {
    await _products.doc(productId).delete();
  }

  /// ==========================
  /// Product Stream
  /// ==========================
  Stream<List<ProductModel>> getProductsStream() {
    return _products
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ProductModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  /// ==========================
  /// Search
  /// ==========================
  Stream<List<ProductModel>> searchProducts(
    String keyword,
  ) {
    return getProductsStream().map(
      (products) => products.where(
        (product) {
          return product.name
                  .toLowerCase()
                  .contains(
                    keyword.toLowerCase(),
                  ) ||
              product.category
                  .toLowerCase()
                  .contains(
                    keyword.toLowerCase(),
                  );
        },
      ).toList(),
    );
  }

  /// ==========================
  /// Update Stock
  /// ==========================
  Future<void> updateStock(
    String productId,
    int stock,
  ) async {
    await _products.doc(productId).update({
      'stock': stock,
    });
  }

  /// ==========================
  /// Availability
  /// ==========================
  Future<void> updateAvailability(
    String productId,
    bool value,
  ) async {
    await _products.doc(productId).update({
      'isAvailable': value,
    });
  }

  /// ==========================
  /// Total Products
  /// ==========================
  Stream<int> totalProducts() {
    return _products.snapshots().map(
          (event) => event.docs.length,
        );
  }

  /// ==========================
  /// Low Stock
  /// ==========================
  Stream<int> lowStockProducts() {
    return _products.snapshots().map(
      (event) {
        return event.docs.where((doc) {
          final stock =
              (doc.data()['stock'] ?? 0) as int;
          return stock <= 5;
        }).length;
      },
    );
  }

}