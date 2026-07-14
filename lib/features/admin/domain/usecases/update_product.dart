import '../../data/models/product_model.dart';
import '../repositories/admin_repository.dart';

class UpdateProduct {

  final AdminRepository repository;

  UpdateProduct(this.repository);

  Future<void> call(
    ProductModel product,
  ) {

    return repository.updateProduct(product);

  }
}