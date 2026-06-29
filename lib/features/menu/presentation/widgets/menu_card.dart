import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/admin/data/models/product_model.dart';

import 'package:my_project26_fixed/features/cart/cart_provider.dart';
import 'package:my_project26_fixed/features/cart/domain/cart_model.dart';

class MenuCard extends ConsumerStatefulWidget {
  final ProductModel product;

  const MenuCard({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends ConsumerState<MenuCard> {

  bool favourite = false;

  int quantity = 1;

  @override
  Widget build(BuildContext context) {

    final product = widget.product;

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 300,
      ),

      margin: const EdgeInsets.only(
        bottom: 18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(24),

        boxShadow: [

          BoxShadow(
            color: Colors.red.withOpacity(.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),

        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            /// IMAGE SECTION
            Stack(
              children: [

                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20),

                  child: product.imageUrl.trim().isEmpty

                      ? Container(
                          width: 105,
                          height: 105,

                          decoration:
                              const BoxDecoration(

                            gradient:
                                LinearGradient(

                              colors: [

                                Color(0xffD32F2F),

                                Color(0xffFF9800),

                              ],
                            ),
                          ),

                          child: const Icon(
                            Icons.fastfood,
                            color: Colors.white,
                            size: 45,
                          ),
                        )

                      : Image.network(

                          product.imageUrl,

                          width: 105,

                          height: 105,

                          fit: BoxFit.cover,

                          errorBuilder:
                              (_, __, ___) {

                            return Container(

                              width: 105,

                              height: 105,

                              decoration:
                                  const BoxDecoration(

                                gradient:
                                    LinearGradient(

                                  colors: [

                                    Color(0xffD32F2F),

                                    Color(0xffFF9800),

                                  ],
                                ),
                              ),

                              child: const Icon(

                                Icons.fastfood,

                                color: Colors.white,

                                size: 45,

                              ),
                            );
                          },
                        ),
                ),

                Positioned(
                  top: 8,
                  left: 8,

                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(

                      color: Colors.red,

                      borderRadius:
                          BorderRadius.circular(30),

                    ),

                    child: const Text(

                      "HOT",
                      

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 11,

                        fontWeight:
                            FontWeight.bold,

                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (product.discount > 0)

Positioned(
  bottom: 8,
  left: 8,
  child: Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 4,
    ),
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius:
          BorderRadius.circular(20),
    ),
    child: Text(
      "-${product.discount.toInt()}%",
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 11,
      ),
    ),
  ),
),

            const SizedBox(width: 15),

            Expanded(

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [ /// Name + Favorite
Row(
  children: [
    Expanded(
      child: Text(
        product.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xff222222),
        ),
      ),
    ),

    InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        setState(() {
          favourite = !favourite;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: favourite
              ? Colors.red.shade50
              : Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          favourite
              ? Icons.favorite
              : Icons.favorite_border,
          color: favourite
              ? Colors.red
              : Colors.grey,
          size: 20,
        ),
      ),
    ),
  ],
),

const SizedBox(height: 10),

/// Category Chip
Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  ),
  decoration: BoxDecoration(
    color: Colors.orange.shade100,
    borderRadius: BorderRadius.circular(30),
  ),
  child: Text(
    product.category,
    style: TextStyle(
      color: Colors.deepOrange.shade700,
      fontWeight: FontWeight.w600,
      fontSize: 13,
    ),
  ),
),

const SizedBox(height: 10),

/// Rating + Delivery
Row(
  children: [

    const Icon(
      Icons.star,
      color: Colors.amber,
      size: 18,
    ),

    const SizedBox(width: 4),

    const Text(
      "4.8",
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),

    const SizedBox(width: 14),

    Icon(
      Icons.delivery_dining,
      color: Colors.deepOrange.shade400,
      size: 18,
    ),

    const SizedBox(width: 4),

    const Text(
      "20-30 min",
      style: TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    ),
  ],
),

const SizedBox(height: 10),

/// Offer Badge
Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 5,
  ),
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xffD32F2F),
        Color(0xffFF9800),
      ],
    ),
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Text(
    "🔥 20% OFF",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    ),
  ),
),

const SizedBox(height: 14),

/// Price
Column(
  crossAxisAlignment:
      CrossAxisAlignment.start,
  children: [

    Text(
      "৳ ${product.finalPrice.toStringAsFixed(0)}",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: Colors.deepOrange,
      ),
    ),

    if (product.discount > 0)

      Text(
        "৳ ${product.price.toStringAsFixed(0)}",
        style: const TextStyle(
          decoration:
              TextDecoration.lineThrough,
          color: Colors.grey,
        ),
      ),
  ],
),

const SizedBox(height: 16),
/// Quantity + Add to Cart
Row(
  children: [
    Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [

          InkWell(
            onTap: () {
              if (quantity > 1) {
                setState(() {
                  quantity--;
                });
              }
            },
            borderRadius: BorderRadius.circular(30),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.remove,
                size: 18,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              "$quantity",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          InkWell(
            onTap: () {
              setState(() {
                quantity++;
              });
            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xffD32F2F),
                    Color(0xffFF9800),
                  ],
                ),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    ),

    const Spacer(),

    Expanded(
      child: SizedBox(
        height: 46,
        child: ElevatedButton.icon(
          onPressed: () {
  ref.read(cartProvider.notifier).addToCart(
        CartModel(
          productId: product.id,
          name: product.name,
          imageUrl: product.imageUrl,
          price: product.finalPrice,
          quantity: quantity,
          isSelected: true,
        ),
      );

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      content: Text(
        "${product.name} added successfully",
      ),
    ),
  );
},
          icon: const Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
            size: 20,
          ),
          label: const Text(
            "Add",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    ),
  ],
),                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}