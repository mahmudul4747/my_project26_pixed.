import '../../data/models/product_model.dart';
import '../repositories/admin_repository.dart';

class AddProduct {

  final AdminRepository repository;

  AddProduct(this.repository);

  Future<void> call(
    ProductModel product,
  ) {

    return repository.addProduct(product);

  }
}