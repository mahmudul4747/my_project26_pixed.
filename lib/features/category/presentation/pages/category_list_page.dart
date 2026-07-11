import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/category/providers/category_provider.dart';
import '../../data/models/category_model.dart';
import '../../data/services/category_service.dart';
import 'edit_category_page.dart';

class CategoryListPage extends ConsumerStatefulWidget {
  const CategoryListPage({super.key});

  @override
  ConsumerState<CategoryListPage> createState() =>
      _CategoryListPageState();
}

class _CategoryListPageState
    extends ConsumerState<CategoryListPage> {
  final _searchController = TextEditingController();

  String search = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> refresh() async {
    ref.invalidate(categoryStreamProvider);

    await Future.delayed(
      const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryAsync =
        ref.watch(categoryStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Categories",
        ),
        centerTitle: true,
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add-category',
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [

          Padding(
            padding:
                const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText:
                    "Search Category",
                prefixIcon:
                    const Icon(Icons.search),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  search =
                      value.toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: categoryAsync.when(

              loading: () =>
                  const Center(
                child:
                    CircularProgressIndicator(),
              ),

              error: (e, s) => Center(
                child: Text(
                  e.toString(),
                ),
              ),

              data: (categories) {

                final filtered =
                    categories.where(
                  (element) {

                    return element.name
                        .toLowerCase()
                        .contains(search);

                  },
                ).toList();

                if (filtered.isEmpty) {

                  return RefreshIndicator(
                    onRefresh: refresh,
                    child: ListView(
                      children: const [

                        SizedBox(
                          height: 120,
                        ),

                        Icon(
                          Icons.category,
                          size: 90,
                          color: Colors.grey,
                        ),

                        SizedBox(
                          height: 15,
                        ),

                        Center(
                          child: Text(
                            "No Category Found",
                          ),
                        ),

                      ],
                    ),
                  );

                }

                return RefreshIndicator(
                  onRefresh: refresh,

                  child: ListView.builder(

                    padding:
                        const EdgeInsets.all(16),

                    itemCount:
                        filtered.length,

                    itemBuilder:
                        (context, index) {

                      final CategoryModel category =
                          filtered[index];
                                                return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),

                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: category.imageUrl.isNotEmpty
                                ? Image.network(
                                    category.imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) {
                                      return Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.grey.shade200,
                                        child: const Icon(
                                          Icons.category,
                                          color: Colors.deepOrange,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.category,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                          ),

                          title: Text(
                            category.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          subtitle: Text(
                            category.id,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditCategoryPage(
                                        category: category,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {

                                  final result =
                                      await showDialog<bool>(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Delete Category",
                                        ),
                                        content: Text(
                                          "Delete '${category.name}' ?",
                                        ),
                                        actions: [

                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                context,
                                                false,
                                              );
                                            },
                                            child: const Text(
                                              "Cancel",
                                            ),
                                          ),

                                          FilledButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                context,
                                                true,
                                              );
                                            },
                                            child: const Text(
                                              "Delete",
                                            ),
                                          ),

                                        ],
                                      );
                                    },
                                  );

                                  if (result == true) {

                                    await CategoryService()
                                        .deleteCategory(
                                      category.id,
                                    );

                                    if (!mounted) return;

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Category Deleted",
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}