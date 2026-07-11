import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final String _collection = "categories";

  Stream<List<CategoryModel>> getCategories() {
    return _firestore
        .collection(_collection)
        .orderBy(
          "createdAt",
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => CategoryModel.fromMap(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  Future<void> addCategory(
      CategoryModel category) async {
    await _firestore
        .collection(_collection)
        .add(category.toMap());
  }

  Future<void> updateCategory(
    String id, {
    required String name,
    required String imageUrl,
  }) async {
    await _firestore
        .collection(_collection)
        .doc(id)
        .update({
      "name": name,
      "imageUrl": imageUrl,
    });
  }

  Future<void> deleteCategory(
      String id) async {
    await _firestore
        .collection(_collection)
        .doc(id)
        .delete();
  }
}