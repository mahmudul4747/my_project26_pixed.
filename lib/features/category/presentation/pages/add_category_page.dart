import 'package:flutter/material.dart';

import '../../data/models/category_model.dart';
import '../../data/services/category_service.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() =>
      _AddCategoryPageState();
}

class _AddCategoryPageState
    extends State<AddCategoryPage> {

  final CategoryService _service =
      CategoryService();

  final _formKey =
      GlobalKey<FormState>();

  final _nameController =
      TextEditingController();

  final _imageController =
      TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {

      final category = CategoryModel(
        id: '',
        name: _nameController.text.trim(),
        imageUrl: _imageController.text.trim(),
        createdAt: DateTime.now(),
      );

      await _service.addCategory(category);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Category Added Successfully",
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Add Category",
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Category Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Enter category name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: "Image Url",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,
                height: 50,

                child: FilledButton(

                  onPressed: _loading
                      ? null
                      : _saveCategory,

                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Save Category",
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}