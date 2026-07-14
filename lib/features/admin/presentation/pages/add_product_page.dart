import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/datasource/admin_remote_datasource.dart';
import '../../data/models/product_model.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final _datasource = AdminRemoteDatasource();

  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final product = ProductModel(
        id: '',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _categoryController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        discount: double.tryParse(_discountController.text.trim()) ?? 0,
        stock: int.parse(_stockController.text.trim()),
      );

      await _datasource.addProduct(product: product);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product Added Successfully')),
      );

      context.pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    bool isImageUrl = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: isImageUrl ? (_) => setState(() {}) : null,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Required';
          }

          if (isImageUrl &&
              !(value.startsWith('http://') || value.startsWith('https://'))) {
            return 'Enter a valid image URL';
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _imageUrlController.text.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(_nameController, 'Name'),
              _field(_descriptionController, 'Description'),
              _field(_categoryController, 'Category'),
              _field(
                _priceController,
                'Price',
                keyboardType: TextInputType.number,
              ),
              _field(
                _discountController,
                'Discount (%)',
                keyboardType: TextInputType.number,
              ),
              _field(
                _stockController,
                'Stock',
                keyboardType: TextInputType.number,
              ),
              _field(
                _imageUrlController,
                'Image URL',
                keyboardType: TextInputType.url,
                isImageUrl: true,
              ),
              if (imageUrl.startsWith('http'))
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(
                      height: 80,
                      child: Center(
                        child: Text('Image URL is not valid'),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _save,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Save Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}