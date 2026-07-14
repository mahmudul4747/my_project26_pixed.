import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/datasource/admin_remote_datasource.dart';
import '../../data/models/product_model.dart';


class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {

    final datasource = AdminRemoteDatasource();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),

      body: StreamBuilder<List<ProductModel>>(
        stream: datasource.getProducts(),

        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(
              child: Text("No Products Found"),
            );
          }

          final products = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,

            itemBuilder: (context,index){

              final product = products[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom:12),

                child: ListTile(

                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),

                    child: Image.network(
                      product.imageUrl,
                      width:60,
                      height:60,
                      fit:BoxFit.cover,

                      errorBuilder:(context,error,stack){
                        return const Icon(Icons.image);
                      },
                    ),
                  ),

                  title: Text(
                    product.name,
                    maxLines:1,
                    overflow:TextOverflow.ellipsis,
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(
                        "Price: ${product.price}",
                      ),

                      Text(
                        "Stock: ${product.stock}",
                      ),

                    ],
                  ),

                  trailing: PopupMenuButton(

                    itemBuilder:(context)=>[

                      const PopupMenuItem(
                        value:"edit",
                        child:Text("Edit"),
                      ),

                      const PopupMenuItem(
                        value:"delete",
                        child:Text("Delete"),
                      ),

                    ],

                    onSelected:(value) async {

                      if(value=="edit"){

                        context.push(
                          "/admin/edit-product",
                          extra: product,
                        );

                      }


                      if(value=="delete"){

                        await datasource.deleteProduct(
                          product.id,
                        );

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content:Text(
                              "Product Deleted",
                            ),
                          ),
                        );

                      }

                    },

                  ),

                ),

              );

            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed:(){

          context.push(
            "/admin/add-product",
          );

        },

        child:const Icon(
          Icons.add,
        ),
      ),

    );
  }
}