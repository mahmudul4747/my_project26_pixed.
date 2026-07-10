class OrderItemModel {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  

  const OrderItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
  return OrderItemModel(
    productId: map['productId'] ?? '',
    name: map['name'] ?? '',
    price: (map['price'] ?? 0).toDouble(),
    quantity: map['quantity'] ?? 1,
    imageUrl: map['imageUrl'] ?? '',
  );
}
}