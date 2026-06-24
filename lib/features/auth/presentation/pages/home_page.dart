import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/admin/pressentation/providers/product_provider.dart';
import 'package:my_project26_fixed/features/cart/cart_provider.dart';
import 'package:my_project26_fixed/features/cart/domain/cart_model.dart';
import 'package:go_router/go_router.dart';




class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              context.push('/cart');
            },
          )
        ],
      ),
      body: products.when(
  data: (items) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final product = items[index];

        return Card(
          child: Column(
            children: [
              Image.network(product.imageUrl),

              Text(product.name),

              Text(product.category),

              Text("৳ ${product.finalPrice}"),

              ElevatedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).addToCart(
                    CartModel(
                      id: product.id,
                      name: product.name,
                      price: product.finalPrice,
                      imageUrl: product.imageUrl,
                    ),
                  );
                },
                child: const Text("Add"),
              ),
            ],
          ),
        );
      },
    );
  },
  loading: () => const CircularProgressIndicator(),
  error: (e, _) => Text(e.toString()),
),
    );
    }
    }
  
