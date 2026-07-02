import 'package:flutter/material.dart';
import 'package:my_project26_fixed/features/admin/data/models/product_model.dart';
import 'package:my_project26_fixed/features/admin/data/services/product_service.dart';

import '../widgets/menu_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_chips.dart';
import '../widgets/specialbanner.dart';
import '../widgets/empty_menu.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final ProductService _service = ProductService();

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
            child: StreamBuilder<List<ProductModel>>(
              stream: _service.getProductsStream(),

              builder: (context, snapshot) {

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(
                      color: Colors.deepOrange,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                }

                final allProducts =
                    snapshot.data ?? [];

                final products =
                    allProducts.where((item) {

                  return item.name
                          .toLowerCase()
                          .contains(_search) ||

                      item.category
                          .toLowerCase()
                          .contains(_search);

                }).toList();

                if (products.isEmpty) {
                  return const EmptyMenu();
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.all(16),

                  itemCount: products.length,

                  itemBuilder:
                      (context, index) {

                    return MenuCard(
                      product: products[index],
                    );
                  },
                );
              },
            ),
          ),        ],
      ),
    );
  }
}