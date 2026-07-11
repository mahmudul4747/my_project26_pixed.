import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/product_model.dart';
import '../providers/product_provider.dart';
import '../../data/services/product_service.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() =>
      _ProductListPageState();
}

class _ProductListPageState
    extends ConsumerState<ProductListPage> {
  final ProductService _service = ProductService();

  final TextEditingController searchController =
      TextEditingController();

  String keyword = "";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteProduct(
      ProductModel product) async {
    final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Delete Product"),
            content: Text(
              "Delete ${product.name} ?",
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () =>
                    Navigator.pop(context, true),
                child: const Text("Delete"),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    await _service.deleteProduct(product.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Product Deleted",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products =
        ref.watch(productStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Management",
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(productStreamProvider);
        },

        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search Product",
                  prefixIcon:
                      const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    keyword =
                        value.trim().toLowerCase();
                  });
                },
              ),
            ),

            Expanded(
              child: products.when(
                loading: () => const Center(
                  child:
                      CircularProgressIndicator(),
                ),

                error: (e, _) => Center(
                  child: Text(e.toString()),
                ),

                data: (list) {
                  final filtered = list.where(
                    (product) {
                      if (keyword.isEmpty) {
                        return true;
                      }

                      return product.name
                              .toLowerCase()
                              .contains(keyword) ||
                          product.category
                              .toLowerCase()
                              .contains(keyword);
                    },
                  ).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Product Found",
                      ),
                    );
                  }

                  return ListView.builder(
                    padding:
                        const EdgeInsets.only(
                      bottom: 100,
                    ),
                    itemCount: filtered.length,
                    itemBuilder:
                        (context, index) {
                      final product =
                          filtered[index];

                      return Card(
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),

                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                                    10),
                            child: Image.network(
                              product.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) =>
                                      Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey
                                    .shade200,
                                child: const Icon(
                                  Icons.fastfood,
                                ),
                              ),
                            ),
                          ),

                          title: Text(
                            product.name,
                          ),

                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [

                              Text(
                                product.category,
                              ),

                              Text(
                                "৳ ${product.finalPrice.toStringAsFixed(2)}",
                              ),

                              Text(
                                "Stock : ${product.stock}",
                              ),
                                                            const SizedBox(height: 6),

                              Row(
                                children: [
                                  const Text(
                                    "Available",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Switch(
                                    value: product.isAvailable,
                                    onChanged: (value) async {
                                      await _service.updateAvailability(
                                        product.id,
                                        value,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),

                          trailing: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == "edit") {
                                if (!mounted) return;

                                context.push(
                                  '/edit-product',
                                  extra: product,
                                );
                              }

                              if (value == "delete") {
                                await _deleteProduct(product);
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: "edit",
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 10),
                                    Text("Edit"),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: "delete",
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Delete",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/add-product');
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Product"),
      ),
    );
  }
}