import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/admin/data/models/product_model.dart';
import 'package:my_project26_fixed/features/cart/cart_provider.dart';
import 'package:my_project26_fixed/features/cart/domain/cart_model.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailsPage({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductDetailsPage> createState() =>
      _ProductDetailsPageState();
}

class _ProductDetailsPageState
    extends ConsumerState<ProductDetailsPage> {

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      body: SafeArea(
        child: Column(
          children: [

            // Image 
            SizedBox(
  height: 330,
  child: Stack(
    children: [
      Hero(
        tag: product.id,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
          ),
          child: Image.network(
            product.imageUrl,
            width: double.infinity,
            height: 330,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(
                    Icons.fastfood,
                    size: 80,
                    color: Colors.orange,
                  ),
                ),
              );
            },
          ),
        ),
      ),

      Positioned(
        top: 16,
        left: 16,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),

      Positioned(
        top: 16,
        right: 16,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              // TODO: Wishlist
            },
          ),
        ),
      ),

      if (product.discount > 0)
        Positioned(
          left: 20,
          bottom: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              "${product.discount.toInt()}% OFF",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
    ],
  ),
),


            // Details Section
            Expanded(
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            product.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  product.category,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.star,
                color: Colors.amber,
              ),

              const SizedBox(width: 4),

              const Text(
                "4.8",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                " (120 Reviews)",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            "Description",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            product.description,
            style: TextStyle(
              height: 1.7,
              color: Colors.grey.shade700,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Price",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [

              if (product.discount > 0)
                Text(
                  "৳${product.price.toStringAsFixed(0)}",
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),

              if (product.discount > 0)
                const SizedBox(width: 10),

              Text(
                "৳${product.finalPrice.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
  "Quantity",
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

Row(
  children: [

    IconButton(
      onPressed: () {
        if (quantity > 1) {
          setState(() {
            quantity--;
          });
        }
      },
      icon: const Icon(Icons.remove_circle),
      color: Colors.deepOrange,
      iconSize: 34,
    ),

    Text(
      quantity.toString(),
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),

    IconButton(
      onPressed: () {
        setState(() {
          quantity++;
        });
      },
      icon: const Icon(Icons.add_circle),
      color: Colors.deepOrange,
      iconSize: 34,
    ),
  ],
),



          const SizedBox(height: 12),

        ],
      ),
    ),
  ),
),


            // Bottom Button

          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 20,
        ),
      ],
    ),

    child: SizedBox(
      height: 60,

      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        icon: const Icon(Icons.shopping_cart),

        label: Text(
          "Add To Cart • ৳${(product.finalPrice * quantity).toStringAsFixed(0)}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        onPressed: () {
  ref.read(cartProvider.notifier).addToCart(
    CartModel(
      productId: product.id,
      name: product.name,
      imageUrl: product.imageUrl,
      price: product.finalPrice,
      quantity: quantity,
      isSelected: true,
    ),
  );

 ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text("${product.name} added to cart"),
  ),
);

Future.delayed(const Duration(milliseconds: 500), () {
  if (mounted) {
    Navigator.pop(context);
  }
});
},
      ),
    ),
  ),
),
    );
  }
}