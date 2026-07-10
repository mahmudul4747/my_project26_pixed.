import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_project26_fixed/features/checkout/domain/order_model.dart';



class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Place Order
  Future<void> placeOrder(OrderModel order) async {
  try {
    await _firestore.collection('orders').add(order.toMap());
  } on FirebaseException catch (e) {
    throw Exception(e.message);
  } catch (e) {
    throw Exception('Failed to place order: $e');
  }
}

  // 2. User Orders
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

  // 3. All Orders (Admin)
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

  // 4. Update Status
 Future<void> updateOrderStatus(
  String orderId,
  String status,
) async {
  try {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status,
    });
  } on FirebaseException catch (e) {
    throw Exception(e.message);
  } catch (e) {
    throw Exception('Failed to update order status: $e');
  }
}
  // 5. Delete Order
  Future<void> deleteOrder(String orderId) async {
  try {
    await _firestore.collection('orders').doc(orderId).delete();
  } on FirebaseException catch (e) {
    throw Exception(e.message);
  } catch (e) {
    throw Exception('Failed to delete order: $e');
  }
}
}