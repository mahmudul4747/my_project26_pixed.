class OrderModel {
  final String customerName;
  final String phone;
  final String address;
  final String paymentMethod;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.customerName,
    required this.phone,
    required this.address,
    required this.paymentMethod,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'phone': phone,
      'address': address,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': status,
      'createdAt': createdAt,
    };
  }
}