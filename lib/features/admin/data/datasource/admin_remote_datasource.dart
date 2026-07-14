/*import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

import '../models/dashboard_stats_model.dart';
import '../models/product_model.dart';

class AdminRemoteDatasource {
  AdminRemoteDatasource();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseStorage _storage =
      FirebaseStorage.instance;

  //==============================
  // Collections
  //==============================

  CollectionReference<Map<String, dynamic>>
      get _productRef =>
          _firestore.collection("products");

  CollectionReference<Map<String, dynamic>>
      get _categoryRef =>
          _firestore.collection("categories");

  CollectionReference<Map<String, dynamic>>
      get _orderRef =>
          _firestore.collection("orders");

  //==================================================
  // Upload Product Image
  //==================================================

  Future<String> uploadProductImage(
    File image,
  ) async {
    try {
      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}";

      final ref = _storage
          .ref()
          .child("products")
          .child(fileName);

      final task = await ref.putFile(image);

      return await task.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception(
        "Image Upload Failed : ${e.message}",
      );
    } catch (e) {
      throw Exception(
        "Image Upload Failed : $e",
      );
    }
  }

  //==================================================
  // Delete Product Image
  //==================================================

  Future<void> deleteImage(
    String imageUrl,
  ) async {
    try {
      if (imageUrl.isEmpty) return;

      await FirebaseStorage.instance
          .refFromURL(imageUrl)
          .delete();
    } catch (_) {}
  }

  //==================================================
  // Dashboard Analytics
  //==================================================

  Future<DashboardStatsModel>
      getDashboardStats() async {
    try {
      final products =
          await _productRef.get();

      final categories =
          await _categoryRef.get();

      final orders =
          await _orderRef.get();

      double revenue = 0;

      for (final doc in orders.docs) {
        final data = doc.data();

        revenue +=
            (data["total"] ?? 0)
                .toDouble();
      }

      return DashboardStatsModel(
        totalProducts:
            products.docs.length,

        totalCategories:
            categories.docs.length,

        totalOrders:
            orders.docs.length,

        totalRevenue: revenue,
      );
    } on FirebaseException catch (e) {
      throw Exception(
        e.message ??
            "Dashboard Error",
      );
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  //==================================================
  // Orders Count
  //==================================================

  Future<int> getOrdersCount() async {
    final snap =
        await _orderRef.get();

    return snap.docs.length;
  }

  //==================================================
  // Product Count
  //==================================================

  Future<int> getProductsCount() async {
    final snap =
        await _productRef.get();

    return snap.docs.length;
  }

  //==================================================
  // Category Count
  //==================================================

  Future<int> getCategoryCount() async {
    final snap =
        await _categoryRef.get();

    return snap.docs.length;
  }

  //==================================================
  // Total Revenue
  //==================================================

  Future<double> getRevenue() async {
    final snap =
        await _orderRef.get();

    double revenue = 0;

    for (final item in snap.docs) {
      revenue +=
          (item.data()["total"] ?? 0)
              .toDouble();
    }

    return revenue;
  }

  //==================================================
  // Product Stream
  //==================================================

  Stream<List<ProductModel>>
      getProducts() {
    return _productRef
        .orderBy(
          "createdAt",
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (e) =>
                    ProductModel.fromMap(
                  e.data(),
                  e.id,
                ),
              )
              .toList(),
        );

  }  //==================================================
  // Add Product
  //==================================================

  Future<void> addProduct({
    required ProductModel product,
    File? imageFile,
  }) async {
    try {
      String imageUrl = product.imageUrl;

      if (imageFile != null) {
        imageUrl = await uploadProductImage(imageFile);
      }

      final doc = _productRef.doc();

      final data = product.toMap();

      data["imageUrl"] = imageUrl;
      data["createdAt"] = FieldValue.serverTimestamp();
      data["updatedAt"] = FieldValue.serverTimestamp();

      await doc.set(data);
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? "Failed to add product.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //==================================================
  // Update Product
  //==================================================

  Future<void> updateProduct({
    required ProductModel product,
    File? newImage,
  }) async {
    try {
      String imageUrl = product.imageUrl;

      if (newImage != null) {
        if (product.imageUrl.isNotEmpty) {
          await deleteImage(product.imageUrl);
        }

        imageUrl = await uploadProductImage(newImage);
      }

      final data = product.toMap();

      data["imageUrl"] = imageUrl;
      data["updatedAt"] = FieldValue.serverTimestamp();

      await _productRef
          .doc(product.id)
          .update(data);
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? "Failed to update product.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //==================================================
  // Delete Product
  //==================================================

  Future<void> deleteProduct(
    ProductModel product,
  ) async {
    try {
      if (product.imageUrl.isNotEmpty) {
        await deleteImage(product.imageUrl);
      }

      await _productRef
          .doc(product.id)
          .delete();
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? "Failed to delete product.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //==================================================
  // Get Product By Id
  //==================================================

  Future<ProductModel?> getProductById(
    String id,
  ) async {
    try {
      final doc = await _productRef.doc(id).get();

      if (!doc.exists) return null;

      return ProductModel.fromMap(
        doc.data()!,
        doc.id,
      );
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? "Failed to load product.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //==================================================
  // Search Products
  //==================================================

  Future<List<ProductModel>> searchProducts(
    String keyword,
  ) async {
    try {
      final query = keyword.trim().toLowerCase();

      final snap = await _productRef.get();

      return snap.docs
          .map(
            (e) => ProductModel.fromMap(
              e.data(),
              e.id,
            ),
          )
          .where(
            (item) => item.name
                .toLowerCase()
                .contains(query),
          )
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? "Search failed.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //==================================================
  // Get Products By Category
  //==================================================

  Stream<List<ProductModel>>
      getProductsByCategory(
    String category,
  ) {
    return _productRef
        .where(
          "category",
          isEqualTo: category,
        )
        .orderBy(
          "createdAt",
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (e) => ProductModel.fromMap(
                  e.data(),
                  e.id,
                ),
              )
              .toList(),
        );
  }
    //==================================================
  // Low Stock Products
  //==================================================

  Future<List<ProductModel>> getLowStockProducts({
    int threshold = 5,
  }) async {
    try {
      final snap = await _productRef
          .where("stock", isLessThanOrEqualTo: threshold)
          .orderBy("stock")
          .get();

      return snap.docs
          .map(
            (e) => ProductModel.fromMap(
              e.data(),
              e.id,
            ),
          )
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(
        e.message ?? "Failed to load low stock products.",
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //==================================================
  // Recent Products
  //==================================================

  Future<List<ProductModel>> getRecentProducts({
    int limit = 10,
  }) async {
    try {
      final snap = await _productRef
          .orderBy(
            "createdAt",
            descending: true,
          )
          .limit(limit)
          .get();

      return snap.docs
          .map(
            (e) => ProductModel.fromMap(
              e.data(),
              e.id,
            ),
          )
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(
        e.message ?? "Failed to load recent products.",
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //==================================================
  // Recent Orders
  //==================================================

  Future<List<Map<String, dynamic>>> getRecentOrders({
    int limit = 10,
  }) async {
    try {
      final snap = await _orderRef
          .orderBy(
            "createdAt",
            descending: true,
          )
          .limit(limit)
          .get();

      return snap.docs
          .map((e) => e.data())
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(
        e.message ?? "Failed to load recent orders.",
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //==================================================
  // Batch Delete Products
  //==================================================

  Future<void> deleteProducts(
    List<ProductModel> products,
  ) async {
    try {
      final batch = _firestore.batch();

      for (final product in products) {
        if (product.imageUrl.isNotEmpty) {
          await deleteImage(product.imageUrl);
        }

        batch.delete(
          _productRef.doc(product.id),
        );
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception(
        e.message ?? "Batch delete failed.",
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //==================================================
  // Refresh Dashboard
  //==================================================

  Future<DashboardStatsModel> refreshDashboard() async {
    return getDashboardStats();
  }
}*/
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dashboard_stats_model.dart';
import '../models/product_model.dart';


class AdminRemoteDatasource {


  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;



  // =========================
  // Add Product
  // =========================

  Future<void> addProduct({
    required ProductModel product,
  }) async {


    final doc =
    _firestore.collection("products").doc();


    await doc.set({

      ...product.toMap(),

      "id": doc.id,

      "createdAt":
      FieldValue.serverTimestamp(),

    });


  }




  // =========================
  // Update Product
  // =========================

  Future<void> updateProduct({
    required ProductModel product,
  }) async {


    await _firestore
        .collection("products")
        .doc(product.id)
        .update(

      product.toMap(),

    );


  }




  // =========================
  // Delete Product
  // =========================

  Future<void> deleteProduct(
      String productId,
      ) async {


    await _firestore
        .collection("products")
        .doc(productId)
        .delete();


  }





  // =========================
  // Get All Products
  // =========================

 Stream<List<ProductModel>> getProducts() {
  return _firestore
      .collection("products")
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return ProductModel.fromMap(
        doc.data(),
        doc.id,
      );
    }).toList();
  });
}
  Future<DashboardStatsModel> getDashboardStats() async {
  try {
    final products = await _firestore.collection("products").get();
    final categories = await _firestore.collection("categories").get();
    final orders = await _firestore.collection("orders").get();

    double revenue = 0;

    for (final doc in orders.docs) {
      final data = doc.data();
      revenue += (data["total"] ?? 0).toDouble();
    }

    return DashboardStatsModel(
      totalProducts: products.docs.length,
      totalCategories: categories.docs.length,
      totalOrders: orders.docs.length,
      totalRevenue: revenue,
    );
  } on FirebaseException catch (e) {
    throw Exception(e.message ?? "Dashboard data load failed.");
  }
}



}