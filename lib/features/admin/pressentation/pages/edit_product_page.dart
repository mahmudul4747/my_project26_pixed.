import 'package:flutter/material.dart';

import '../../data/models/product_model.dart';
import '../../data/services/product_service.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;

  const EditProductPage({
    super.key,
    required this.product,
  });

  @override
  State<EditProductPage> createState() =>
      _EditProductPageState();
}

class _EditProductPageState
    extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();

  final ProductService _service = ProductService();

  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  late final TextEditingController discountController;
  late final TextEditingController stockController;
  late final TextEditingController imageController;

  bool isLoading = false;

  bool isAvailable = true;

  String selectedCategory = "Burger";

  final List<String> categories = const [
    "Burger",
    "Pizza",
    "Chicken",
    "Rice",
    "Drinks",
    "Dessert",
    "Coffee",
    "Fast Food",
  ];

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    nameController =
        TextEditingController(text: product.name);

    descriptionController =
        TextEditingController(
      text: product.description,
    );

    priceController =
        TextEditingController(
      text: product.price.toString(),
    );

    discountController =
        TextEditingController(
      text: product.discount.toString(),
    );

    stockController =
        TextEditingController(
      text: product.stock.toString(),
    );

    imageController =
        TextEditingController(
      text: product.imageUrl,
    );

    selectedCategory = product.category;

    isAvailable = product.isAvailable;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    discountController.dispose();
    stockController.dispose();
    imageController.dispose();
    super.dispose();
  }

  Future<void> updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final updatedProduct = ProductModel(
        id: widget.product.id,
        name: nameController.text.trim(),
        description:
            descriptionController.text.trim(),
        price: double.parse(
          priceController.text.trim(),
        ),
        imageUrl:
            imageController.text.trim(),
        category: selectedCategory,
        discount: double.tryParse(
              discountController.text.trim(),
            ) ??
            0,
        stock: int.tryParse(
              stockController.text.trim(),
            ) ??
            0,
        rating: widget.product.rating,
        isAvailable: isAvailable,
        createdAt: widget.product.createdAt,
      );

      await _service.updateProduct(
        updatedProduct,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Product Updated Successfully",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  InputDecoration inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Edit Product"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding:
              const EdgeInsets.all(18),
          children: [

            TextFormField(
              controller: nameController,
              decoration:
                  inputDecoration(
                "Product Name",
                Icons.fastfood,
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return "Enter product name";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller:
                  descriptionController,
              maxLines: 3,
              decoration:
                  inputDecoration(
                "Description",
                Icons.description,
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller:
                  priceController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  inputDecoration(
                "Price",
                Icons.attach_money,
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return "Enter price";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller:
                  discountController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  inputDecoration(
                "Discount %",
                Icons.discount,
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller:
                  stockController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  inputDecoration(
                "Stock",
                Icons.inventory_2,
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration:
                  inputDecoration(
                "Category",
                Icons.category,
              ),
              items: categories
                  .map(
                    (category) =>
                        DropdownMenuItem(
                      value: category,
                      child:
                          Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory =
                      value!;
                });
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller:
                  imageController,
              decoration:
                  inputDecoration(
                "Image URL",
                Icons.image,
              ),
            ),

            const SizedBox(height: 18),

            if (imageController
                .text
                .isNotEmpty)
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                        16),
                child: Image.network(
                  imageController.text,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) {
                    return Container(
                      height: 180,
                      color:
                          Colors.grey.shade200,
                      child:
                          const Center(
                        child: Icon(
                          Icons.image,
                          size: 60,
                        ),
                      ),
                    );
                  },
                ),
              ),
                          const SizedBox(height: 20),

            Card(
              elevation: 0,
              color: Colors.orange.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: SwitchListTile(
                value: isAvailable,
                activeColor: Colors.green,
                title: const Text(
                  "Product Available",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  isAvailable
                      ? "Customers can order this product"
                      : "Hidden from customers",
                ),
                secondary: Icon(
                  isAvailable
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: isAvailable
                      ? Colors.green
                      : Colors.red,
                ),
                onChanged: (value) {
                  setState(() {
                    isAvailable = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading
                    ? null
                    : updateProduct,
                icon: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  isLoading
                      ? "Updating..."
                      : "Update Product",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.orange,
                  foregroundColor:
                      Colors.white,
                  elevation: 2,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}