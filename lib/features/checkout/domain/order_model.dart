import 'package:cloud_firestore/cloud_firestore.dart';

import 'order_item_model.dart';

class OrderModel {
  final String customerName;
  final String phone;
  final String address;
  final String note;

  final String paymentMethod;

  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;

  final String status;

  final DateTime createdAt;

  final List<OrderItemModel> items;

  const OrderModel({
    required this.customerName,
    required this.phone,
    required this.address,
    required this.note,
    required this.paymentMethod,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'phone': phone,
      'address': address,
      'note': note,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'total': total,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'items': items.map((e) => e.toMap()).toList(),
    };
  }

  factory OrderModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return OrderModel(
      customerName: map['customerName'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      note: map['note'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      deliveryFee: (map['deliveryFee'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
      status: map['status'] ?? 'Pending',
      createdAt:
          (map['createdAt'] as Timestamp).toDate(),
      items: (map['items'] as List)
          .map(
            (e) => OrderItemModel(
              productId: e['productId'],
              name: e['name'],
              price: (e['price']).toDouble(),
              quantity: e['quantity'],
              imageUrl: e['imageUrl'],
            ),
          )
          .toList(),
    );
  }
}