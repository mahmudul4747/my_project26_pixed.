import 'package:flutter/material.dart';
import 'package:my_project26_fixed/features/admin/data/models/product_model.dart';
import 'package:my_project26_fixed/features/admin/data/services/product_service.dart';


class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),

      body: StreamBuilder<List<ProductModel>>(
        stream: productService.getProductsStream(),
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(
              child: Text('No Products Found'),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {

              final product = products[index];

              return Card(
                margin: const EdgeInsets.all(8),

                child: ListTile(
                  leading: const Icon(
                    Icons.fastfood,
                  ),

                  title: Text(
                    product.name,
                  ),

                  subtitle: Text(
                    product.category,
                  ),

                  trailing: Text(
                    '${product.price} Tk',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}