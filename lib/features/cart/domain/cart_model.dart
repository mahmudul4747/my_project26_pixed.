class CartModel {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final bool isSelected;

  const CartModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.isSelected = true,
  });

  CartModel copyWith({
    String? productId,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
    bool? isSelected,
  }) {
    return CartModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}