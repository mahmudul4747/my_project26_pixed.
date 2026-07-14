import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/product_model.dart';
import '../../data/datasource/admin_remote_datasource.dart';
import '../../data/datasource/storage_datasource.dart';


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


  final _formKey =
  GlobalKey<FormState>();


  late TextEditingController _nameController;

  late TextEditingController _descriptionController;

  late TextEditingController _categoryController;

  late TextEditingController _priceController;

  late TextEditingController _discountController;

  late TextEditingController _stockController;



  File? _image;


  bool _loading = false;



  final ImagePicker _picker =
  ImagePicker();



  final _datasource =
  AdminRemoteDatasource();



  final _storage =
  StorageDatasource();






  @override
  void initState() {

    super.initState();


    _nameController =
        TextEditingController(
          text: widget.product.name,
        );


    _descriptionController =
        TextEditingController(
          text: widget.product.description,
        );


    _categoryController =
        TextEditingController(
          text: widget.product.category,
        );


    _priceController =
        TextEditingController(
          text: widget.product.price.toString(),
        );


    _discountController =
        TextEditingController(
          text: widget.product.discount.toString(),
        );


    _stockController =
        TextEditingController(
          text: widget.product.stock.toString(),
        );


  }






  @override
  void dispose() {


    _nameController.dispose();

    _descriptionController.dispose();

    _categoryController.dispose();

    _priceController.dispose();

    _discountController.dispose();

    _stockController.dispose();


    super.dispose();

  }







  Future<void> _pickImage() async {


    final picked =
    await _picker.pickImage(

      source:
      ImageSource.gallery,

    );



    if(picked != null){


      setState(() {

        _image =
        File(
          picked.path,
        );

      });


    }


  }







  Future<void> _update() async {



    if(!_formKey.currentState!.validate()){

      return;

    }





    setState(() {

      _loading = true;

    });




    try {



      String imageUrl =
      widget.product.imageUrl;





      if(_image != null){


        imageUrl =
        await _storage.uploadProductImage(
          _image!,
        );


      }





      final updatedProduct =
      ProductModel(


        id:
        widget.product.id,



        name:
        _nameController.text.trim(),



        description:
        _descriptionController.text.trim(),



        category:
        _categoryController.text.trim(),



        imageUrl:
        imageUrl,



        price:
        double.parse(
          _priceController.text,
        ),



        discount:
        double.tryParse(
          _discountController.text,
        ) ?? 0,



        stock:
        int.parse(
          _stockController.text,
        ),


      );






      await _datasource.updateProduct(
        product: updatedProduct,
      );






      if(!mounted) return;




      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "Product Updated Successfully",
          ),

        ),

      );




      context.pop();





    }catch(e){



      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(
            e.toString(),
          ),

        ),

      );


    }





    if(mounted){


      setState(() {

        _loading = false;

      });


    }


  }







  Widget _field(

      TextEditingController controller,

      String label, {

        TextInputType? keyboardType,

      }) {



    return Padding(

      padding:
      const EdgeInsets.only(
        bottom:14,
      ),



      child:

      TextFormField(

        controller:
        controller,


        keyboardType:
        keyboardType,



        validator:(v){


          if(v == null || v.isEmpty){

            return "Required";

          }


          return null;

        },



        decoration:
        InputDecoration(

          labelText:
          label,


          border:
          const OutlineInputBorder(),

        ),

      ),


    );


  }









  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar:

      AppBar(

        title:
        const Text(
          "Edit Product",
        ),

      ),




      body:


      SingleChildScrollView(


        padding:
        const EdgeInsets.all(16),



        child:


        Form(


          key:
          _formKey,



          child:


          Column(


            children: [




              _field(
                _nameController,
                "Name",
              ),




              _field(
                _descriptionController,
                "Description",
              ),




              _field(
                _categoryController,
                "Category",
              ),




              _field(
                _priceController,
                "Price",

                keyboardType:
                TextInputType.number,

              ),




              _field(
                _discountController,
                "Discount (%)",

                keyboardType:
                TextInputType.number,

              ),




              _field(
                _stockController,
                "Stock",

                keyboardType:
                TextInputType.number,

              ),





              const SizedBox(
                height:10,
              ),





              GestureDetector(


                onTap:
                _pickImage,



                child:

                Container(


                  height:
                  160,



                  width:
                  double.infinity,



                  decoration:

                  BoxDecoration(

                    borderRadius:
                    BorderRadius.circular(12),


                    border:
                    Border.all(
                      color:
                      Colors.grey,
                    ),

                  ),




                  child:



                  _image != null


                      ?

                  ClipRRect(

                    borderRadius:
                    BorderRadius.circular(12),


                    child:

                    Image.file(

                      _image!,

                      fit:
                      BoxFit.cover,

                    ),

                  )



                      :


                  widget.product.imageUrl.isNotEmpty


                      ?

                  ClipRRect(

                    borderRadius:
                    BorderRadius.circular(12),


                    child:

                    Image.network(

                      widget.product.imageUrl,

                      fit:
                      BoxFit.cover,

                    ),

                  )



                      :

                  const Center(

                    child:
                    Text(
                      "Select Image",
                    ),

                  ),


                ),


              ),





              const SizedBox(
                height:20,
              ),





              SizedBox(

                width:
                double.infinity,



                child:

                ElevatedButton(


                  onPressed:
                  _loading
                      ? null
                      : _update,



                  child:


                  _loading


                      ?

                  const CircularProgressIndicator()


                      :

                  const Text(
                    "Update Product",
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