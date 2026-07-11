import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/category/data/models/category_model.dart';
import 'package:my_project26_fixed/features/category/data/services/category_service.dart';


final categoryServiceProvider =
    Provider<CategoryService>((ref) {
  return CategoryService();
});

final categoryStreamProvider =
    StreamProvider<List<CategoryModel>>((ref) {
  return ref
      .read(categoryServiceProvider)
      .getCategories();
});