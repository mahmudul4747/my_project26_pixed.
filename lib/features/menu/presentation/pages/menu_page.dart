import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/admin/pressentation/providers/product_provider.dart';
import 'package:my_project26_fixed/features/cart/cart_provider.dart';
import 'package:my_project26_fixed/features/cart/domain/cart_model.dart';
import 'package:my_project26_fixed/features/menu/presentation/pages/product_details_page.dart';
import '../widgets/food_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_chips.dart';
import '../widgets/specialbanner.dart';
import '../widgets/empty_menu.dart';

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  

  final TextEditingController _searchController =
      TextEditingController();

  String _search = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffD32F2F),
                Color(0xffF4511E),
                Color(0xffFF9800),
              ],
            ),
          ),
        ),

        title: const Text(
          "Our Menu",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [           MenuSearchBar(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _search = value
                    .toLowerCase()
                    .trim();
              });
            },
          ),

          const SizedBox(height: 15),

          const SpecialBanner(),

          const SizedBox(height: 18),

          const CategoryChips(),

          const SizedBox(height: 15),
                    Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final productAsync = ref.watch(productStreamProvider);

                        return productAsync.when(
               loading: () => const Center(
          child: CircularProgressIndicator(
            color: Colors.deepOrange,
          ),
        ),

        error: (e, s) => Center(
          child: Text(e.toString()),
        ),

        data: (allProducts) {
          final products = allProducts.where((item) {
            return item.name.toLowerCase().contains(_search) ||
                item.category.toLowerCase().contains(_search);
          }).toList();

          if (products.isEmpty) {
            return const EmptyMenu();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: FoodCard(
                  product: product,
                  layout: FoodCardLayout.vertical,

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
                    // TODO: Wishlist
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
                ),
              );
            },
          );
        },
      );
    },
  ),
),

        ],
      ),
    );               
      
  }
}