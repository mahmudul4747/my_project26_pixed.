import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/admin_remote_datasource.dart';
import '../../data/models/product_model.dart';


final productStreamProvider =
StreamProvider<List<ProductModel>>((ref){

  final datasource =
  AdminRemoteDatasource();

  return datasource.getProducts();

});