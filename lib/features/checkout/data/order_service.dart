import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> placeOrder(OrderModel order) async {
    await _firestore
        .collection('orders')
        .add(order.toMap());
  }
}