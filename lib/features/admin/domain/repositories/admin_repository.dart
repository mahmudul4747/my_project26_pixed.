import '../../data/models/product_model.dart';
import '../../data/models/dashboard_stats_model.dart';

abstract class AdminRepository {
  /// Dashboard
  Future<DashboardStatsModel> getDashboardStats();

  /// Product
  Stream<List<ProductModel>> getProducts();

  Future<void> addProduct(ProductModel product);

  Future<void> updateProduct(ProductModel product);

  Future<void> deleteProduct(String productId);
}