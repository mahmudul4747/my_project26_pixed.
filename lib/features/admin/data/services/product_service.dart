import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final _db = FirebaseFirestore.instance;

  // 🔥 ADD PRODUCT
  Future<void> addProduct(ProductModel product) async {
    await _db.collection('products').add({
      'name': product.name,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'category': product.category,
      'discount': product.discount,
    });
  }

  // STREAM PRODUCTS
  Stream<List<ProductModel>> getProductsStream() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}