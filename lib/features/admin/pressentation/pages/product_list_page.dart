import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];

              return ListTile(
                leading: data['imageUrl'] != ''
                    ? Image.network(
                        data['imageUrl'],
                        width: 50,
                      )
                    : const Icon(Icons.fastfood),

                title: Text(data['name']),
                subtitle: Text(
                  "৳${data['price']}",
                ),
              );
            },
          );
        },
      ),
    );
  }
}