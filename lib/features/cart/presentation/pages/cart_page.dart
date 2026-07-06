import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_project26_fixed/features/cart/cart_provider.dart';
import 'package:my_project26_fixed/features/cart/domain/cart_model.dart';
import 'package:my_project26_fixed/features/cart/presentation/widgets/checkout_box.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  static const _primaryRed = Color(0xFFE53935);
  static const _primaryOrange = Color(0xFFFF9800);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    final totalPrice = cart.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _primaryRed,
                _primaryOrange,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Cart",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),

                        SizedBox(height: 2),

                        Text(
                          "Fresh & Delicious Food",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${cart.length}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: cart.isEmpty
          ? _buildEmptyCart(context)
          : Column(
              children: [

                const SizedBox(height: 12),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    physics:
                        const BouncingScrollPhysics(),

                    itemCount: cart.length,

                    itemBuilder: (context, index) {
                      final CartModel item = cart[index];

                      return _buildCartItem(
                        context,
                        ref,
                        item,
                      );
                    },
                  ),
                ),

                CheckoutBox(
                  totalPrice: totalPrice,
                  onCheckout: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Proceeding to Checkout..."),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xffFFF3F2),
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [

              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.orange.withOpacity(.2),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 70,
                  color: _primaryOrange,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Your Cart is Empty",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Looks like you haven't\nadded any food yet.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: 220,
                height: 55,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        _primaryRed,
                        _primaryOrange,
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.transparent,
                      shadowColor:
                          Colors.transparent,
                    ),
                    child: const Text(
                      "Browse Menu",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(
  BuildContext context,
  WidgetRef ref,
  CartModel item,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Dismissible(
      key: ValueKey(item.productId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
      confirmDismiss: (_) async {
  return await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Remove Item"),
      content: const Text(
        "Are you sure you want to remove this item?",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Remove"),
        ),
      ],
    ),
  );
},

      onDismissed: (_) {
        ref
            .read(cartProvider.notifier)
            .removeFromCart(item.productId);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: item.productId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  item.imageUrl,
                  width: 95,
                  height: 95,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 95,
                      height: 95,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.fastfood,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: const [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "4.9",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "৳ ${item.price.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      _qtyButton(
                        icon: Icons.remove,
                        onTap: () {
                          ref
                              .read(cartProvider.notifier)
                              .decreaseQty(
                                item.productId,
                              );
                        },
                      ),

                      Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        child: Text(
                          "${item.quantity}",
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),

                      _qtyButton(
                        icon: Icons.add,
                        onTap: () {
                          ref
                              .read(cartProvider.notifier)
                              .increaseQty(
                                item.productId,
                              );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {
                ref
                    .read(cartProvider.notifier)
                    .removeFromCart(item.productId);
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _qtyButton({
  required IconData icon,
  required VoidCallback onTap,
}) {
  return AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  child: Material(
    color: const Color(0xFFF5F5F5),
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Icon(
          icon,
          size: 20,
        ),
      ),
    ),
  ),
  );
}
}