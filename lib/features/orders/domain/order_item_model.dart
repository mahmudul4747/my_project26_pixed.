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

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}