import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_project26_fixed/features/cart/cart_provider.dart';
import 'package:my_project26_fixed/features/cart/presentation/widgets/checkout_box.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    final selectedCount = ref.watch(selectedItemCountProvider);

    final allSelected =
        cartItems.isNotEmpty &&
        cartItems.every((item) => item.isSelected);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart ($selectedCount Selected)"),
        actions: [
          TextButton(
            onPressed: () {
              final notifier = ref.read(cartProvider.notifier);

              if (allSelected) {
                notifier.unselectAll();
              } else {
                notifier.selectAll();
              }
            },
            child: Text(
              allSelected ? "Unselect All" : "Select All",
            ),
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                "Cart is empty",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: item.isSelected,
                            onChanged: (_) {
                              ref
                                  .read(cartProvider.notifier)
                                  .toggleSelection(item.productId);
                            },
                          ),
                          title: Row(
                            children: [
                              item.imageUrl.trim().isEmpty
                                  ? const Icon(
                                      Icons.fastfood,
                                      size: 50,
                                    )
                                  : ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(8),
                                      child: Image.network(
                                        item.imageUrl,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) =>
                                                const Icon(
                                          Icons.fastfood,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "৳ ${item.price} x ${item.quantity}",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .decreaseQty(item.productId);
                                },
                              ),
                              Text(
                                "${item.quantity}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .increaseQty(item.productId);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                CheckoutBox(
                  subtotal: total,
                  deliveryFee: 60,
                  discount: 0,
                  onCheckout: () {
                    if (selectedCount == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please select at least one item.",
                          ),
                        ),
                      );
                      return;
                    }

                    context.push('/checkout');
                  },
                ),
              ],
            ),
    );
  }
}