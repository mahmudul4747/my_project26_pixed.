import '../datasource/admin_remote_datasource.dart';
import '../../domain/repositories/admin_repository.dart';
import '../models/dashboard_stats_model.dart';
import '../models/product_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDatasource remote;

  AdminRepositoryImpl(this.remote);

  @override
  Future<void> addProduct(ProductModel product) {
    return remote.addProduct(product: product);
  }

  @override
  Future<void> updateProduct(ProductModel product) {
    return remote.updateProduct(product: product);
  }

  @override
  Future<void> deleteProduct(String productId) {
    return remote.deleteProduct(productId);
  }

  @override
  Stream<List<ProductModel>> getProducts() {
    return remote.getProducts();
  }

  @override
  Future<DashboardStatsModel> getDashboardStats() {
    return (remote as dynamic).getDashboardStats();
  }
}