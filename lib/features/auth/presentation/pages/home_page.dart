import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:my_project26_fixed/features/admin/pressentation/providers/product_provider.dart';
import 'package:my_project26_fixed/features/cart/cart_provider.dart';
import 'package:my_project26_fixed/features/cart/domain/cart_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant Menu"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              context.push('/cart');
            },
          ),
        ],
      ),

      body: products.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text(
                "No Products Found",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: items.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
             childAspectRatio: 0.55,
            ),
            itemBuilder: (context, index) {
              final product = items[index];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [

                    // Product Image
                    Expanded(
                      flex: 5,
                      child: product.imageUrl.trim().isEmpty
                          ? const Center(
                              child: Icon(
                                Icons.fastfood,
                                size: 60,
                              ),
                            )
                          : Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) =>
                                      const Center(
                                child: Icon(
                                  Icons.fastfood,
                                  size: 60,
                                ),
                              ),
                            ),
                    ),

                    // Product Info
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding:
                            const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              product.category,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            const Spacer(),

                            Text(
                              "৳ ${product.finalPrice.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 6),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(cartProvider
                                          .notifier)
                                      .addToCart(
                                        CartModel(
                                          id: product.id,
                                          name:
                                              product.name,
                                          price: product
                                              .finalPrice,
                                          imageUrl: product
                                              .imageUrl,
                                        ),
                                      );

                                  ScaffoldMessenger.of(
                                          context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "${product.name} added to cart",
                                      ),
                                      duration:
                                          const Duration(
                                        seconds: 1,
                                      ),
                                    ),
                                  );
                                },
                                child:
                                    const Text("Add"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },

        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (e, _) => Center(
          child: Text(
            "Error: $e",
          ),
        ),
      ),
    );
  }
}