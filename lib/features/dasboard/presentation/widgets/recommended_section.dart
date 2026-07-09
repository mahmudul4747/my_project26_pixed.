import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_project26_fixed/features/admin/pressentation/providers/product_provider.dart';
import 'package:my_project26_fixed/features/cart/cart_provider.dart';
import 'package:my_project26_fixed/features/cart/domain/cart_model.dart';
import 'package:my_project26_fixed/features/dasboard/presentation/pages/product_details_page.dart';
import 'package:my_project26_fixed/features/dasboard/presentation/providers/category_provider.dart';
import 'package:my_project26_fixed/features/dasboard/presentation/widgets/food_card.dart';
import 'package:my_project26_fixed/features/dasboard/presentation/providers/search_provider.dart';

class RecommendedSection extends ConsumerWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productStreamProvider);
    final search = ref.watch(searchProvider).toLowerCase();
    final selectedCategory = ref.watch(categoryProvider);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recommended",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "See All",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          products.when(
            data: (items) {
              final filteredItems = items.where((product) {
  final matchSearch =
      product.name.toLowerCase().contains(search) ||
      product.category.toLowerCase().contains(search);

  final matchCategory =
      selectedCategory == "All" ||
      product.category.toLowerCase() ==
          selectedCategory.toLowerCase();

  return matchSearch && matchCategory;
}).toList();

  if (filteredItems.isEmpty) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "No products found",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredItems.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: .58,
                ),
                itemBuilder: (context, index) {
                  final product = filteredItems[index];

                  return FoodCard(
                    product: product,

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsPage(
                            product: product,
                          ),
                        ),
                      );
                    },

                    onFavorite: () {
                      // TODO:
                      // Wishlist
                    },

                    onAddToCart: () {
                      ref.read(cartProvider.notifier).addToCart(
                            CartModel(
                              productId: product.id,
                              name: product.name,
                              imageUrl: product.imageUrl,
                              price: product.finalPrice,
                              quantity: 1,
                              isSelected: true,
                            ),
                          );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${product.name} added to cart",
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, s) => Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: Text(e.toString()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}