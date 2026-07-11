import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/services/product_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ProductService _service = ProductService();

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final stockController = TextEditingController();
  final imageController = TextEditingController();

  bool isAvailable = true;
  bool isLoading = false;

  String selectedCategory = "Burger";

  final List<String> categories = const [
    "Burger",
    "Pizza",
    "Chicken",
    "Drinks",
    "Dessert",
    "Coffee",
    "Rice",
    "Fast Food",
  ];

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

  Future<void> saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final product = ProductModel(
        id: '',
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        price: double.parse(priceController.text.trim()),
        imageUrl: imageController.text.trim(),
        category: selectedCategory,
        discount: double.tryParse(
              discountController.text.trim(),
            ) ??
            0,
        rating: 4.5,
        stock:
            int.tryParse(stockController.text.trim()) ??
                0,
        isAvailable: isAvailable,
      );

      await _service.addProduct(product);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Product Added Successfully",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
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

  InputDecoration decoration(
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
        title: const Text("Add Product"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [

            TextFormField(
              controller: nameController,
              decoration: decoration(
                "Product Name",
                Icons.fastfood,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "Enter product name";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: decoration(
                "Description",
                Icons.description,
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: priceController,
              keyboardType:
                  TextInputType.number,
              decoration: decoration(
                "Price",
                Icons.attach_money,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "Enter price";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: discountController,
              keyboardType:
                  TextInputType.number,
              decoration: decoration(
                "Discount %",
                Icons.discount,
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: stockController,
              keyboardType:
                  TextInputType.number,
              decoration: decoration(
                "Stock",
                Icons.inventory,
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: decoration(
                "Category",
                Icons.category,
              ),
              items: categories.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: imageController,
              decoration: decoration(
                "Image URL",
                Icons.image,
              ),
            ),

            const SizedBox(height: 16),

            if (imageController.text.isNotEmpty)
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(16),
                child: Image.network(
                  imageController.text,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) =>
                          const SizedBox(),
                ),
              ),

                          const SizedBox(height: 20),

            SwitchListTile(
              value: isAvailable,
              title: const Text(
                "Available",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                "Show this product to customers",
              ),
              secondary: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              onChanged: (value) {
                setState(() {
                  isAvailable = value;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: isLoading
                    ? null
                    : saveProduct,
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
                      ? "Saving..."
                      : "Save Product",
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
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
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