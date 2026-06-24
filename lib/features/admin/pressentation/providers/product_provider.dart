import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/admin/data/models/product_model.dart';
import 'package:my_project26_fixed/features/admin/data/services/product_service.dart';


final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

final productStreamProvider =
    StreamProvider<List<ProductModel>>((ref) {
  final service = ref.watch(productServiceProvider);
  return service.getProductsStream();
});