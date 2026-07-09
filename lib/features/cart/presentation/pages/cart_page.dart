import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:my_project26_fixed/features/cart/cart_provider.dart';
import 'package:my_project26_fixed/features/cart/domain/cart_model.dart';
import 'package:my_project26_fixed/features/cart/presentation/widgets/checkout_box.dart';
import 'package:my_project26_fixed/features/checkout/presentation/pages/checkout_page.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  static const Color primaryRed = Color(0xFFE53935);
  static const Color primaryOrange = Color(0xFFFF9800);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.read(selectedCartItemsProvider);
    final cartItems = ref.watch(cartProvider);

    final subtotal = cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryRed,
                primaryOrange,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
          )
          , clipBehavior: Clip.antiAlias,

          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
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

                  const SizedBox(width: 4),

                  Expanded(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "My Cart",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text(
                          "${cartItems.length} Items",
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [

                        const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 20,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          "${cartItems.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
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

      body: cartItems.isEmpty
          ? _emptyWidget(context)
          : Column(
              children: [

                const SizedBox(height: 12),

                Expanded(
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),

                    physics:
                        const BouncingScrollPhysics(),

                    itemCount: cartItems.length,

                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 14),

                    itemBuilder: (context, index) {

                      final item = cartItems[index];

                      return _buildCartItem(
                        context,
                        ref,
                        item,
                      );
                    },
                  ),
                ),

                CheckoutBox(
  totalPrice: subtotal,
  onCheckout: () {

    final selected =
        ref.read(selectedCartItemsProvider);

    if (selected.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please select at least one item.",
          ),
        ),
      );

      return;
    }

   context.push(
  '/checkout',
  extra: selectedItems,
);
  },
),
              ],
            ),
    );
  }

  Widget _emptyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [

          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 75,
              color: primaryOrange,
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Cart is Empty",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Add your favourite foods.",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: 200,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                "Browse Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  }Widget _buildCartItem(
  BuildContext context,
  WidgetRef ref,
  CartModel item,
) {
  return Dismissible(
    key: ValueKey(item.productId),
    direction: DismissDirection.endToStart,
    background: Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(22),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 25),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 30,
      ),
    ),
    confirmDismiss: (_) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Remove Item"),
          content: Text(
            "Remove ${item.name} from cart?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                "Remove",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ) ??
      false;
},

onDismissed: (_) {
  ref
      .read(cartProvider.notifier)
      .removeFromCart(item.productId);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("${item.name} removed"),
      backgroundColor: Colors.red,
    ),
  );
},
    child: Card(
      elevation: 2,
      shadowColor: Colors.black12,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Checkbox(
          value: item.isSelected,
          activeColor: CartPage.primaryOrange,
          onChanged: (_) {
            ref
        .read(cartProvider.notifier)
        .toggleSelection(item.productId);
  },
),

            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              
              child: Image.network(
                item.imageUrl,
                width: 85,
                height: 85,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    width: 85,
                    height: 85,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.fastfood),
                  );
                },
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [


                  Row(
                    children: [
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                   
                    ]
                  ),

                  const SizedBox(height: 0),

                  Row(
                    children: [

                      Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.orange,
                      ),

                      SizedBox(width: 5),

                      Text(
                        "4.9",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 50),
                  IconButton(
                        onPressed: () {
                          ref
                              .read(cartProvider.notifier)
                              .removeFromCart(
                                item.productId,
                              );
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 0),
                  Row(
                    children: [


                  Text(
                    "৳ ${item.price.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Color(0xFFE53935),
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20),

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
                          horizontal: 16,
                        ),
                        child: Text(
                          "${item.quantity}",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight:
                                FontWeight.bold,
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
  return Material(
    color: const Color(0xFFF5F5F5),
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: SizedBox(
        width: 38,
        height: 38,
        child: Icon(
          icon,
          size: 16,
        ),
      ),
    ),
  );
}