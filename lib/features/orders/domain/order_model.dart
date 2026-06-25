class OrderModel {
  final String customerName;
  final String phone;
  final String address;
  final double total;
  final DateTime createdAt;

  OrderModel({
    required this.customerName,
    required this.phone,
    required this.address,
    required this.total,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'phone': phone,
      'address': address,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}