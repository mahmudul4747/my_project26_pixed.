import '../../data/models/dashboard_stats_model.dart';
import '../../data/models/product_model.dart';

abstract class AdminRepository {
  Future<void> addProduct(ProductModel product);

  Future<void> updateProduct(ProductModel product);

  Future<void> deleteProduct(String productId);

  Stream<List<ProductModel>> getProducts();

  Future<DashboardStatsModel> getDashboardStats();
}