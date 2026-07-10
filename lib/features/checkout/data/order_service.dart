import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Place Order
  Future<void> placeOrder(OrderModel order) async {
    await _firestore.collection('orders').add(order.toMap());
  }

  /// User Orders
  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Admin - All Orders
  Stream<List<OrderModel>> getAllOrders() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Update Order Status
  Future<void> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status,
    });
  }

  /// Delete Order (Optional)
  Future<void> deleteOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).delete();
  }
}
  