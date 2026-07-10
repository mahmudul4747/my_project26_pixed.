import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/checkout/domain/order_model.dart';

import '../data/order_service.dart';


final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService();
});

final userOrdersProvider =
    StreamProvider.family<List<OrderModel>, String>((ref, userId) {
  return ref.read(orderServiceProvider).getUserOrders(userId);
});

final allOrdersProvider =
    StreamProvider<List<OrderModel>>((ref) {
  return ref.read(orderServiceProvider).getAllOrders();
});
final placeOrderProvider =
    Provider((ref) => ref.read(orderServiceProvider));