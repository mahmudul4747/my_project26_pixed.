import 'package:flutter/material.dart';

import '../../data/models/category_model.dart';
import '../../data/services/category_service.dart';

class EditCategoryPage extends StatefulWidget {
  final CategoryModel category;

  const EditCategoryPage({
    super.key,
    required this.category,
  });

  @override
  State<EditCategoryPage> createState() =>
      _EditCategoryPageState();
}

class _EditCategoryPageState
    extends State<EditCategoryPage> {

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _imageController = TextEditingController();

  bool _loading = false;

  final CategoryService _service =
      CategoryService();

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.category.name;
    _imageController.text = widget.category.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _updateCategory() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {

      await _service.updateCategory(
        widget.category.id,
        name: _nameController.text.trim(),
        imageUrl: _imageController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Category Updated Successfully",
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
          "Edit Category",
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
                  labelText: "Image URL",
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
                      : _updateCategory,

                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Update Category",
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