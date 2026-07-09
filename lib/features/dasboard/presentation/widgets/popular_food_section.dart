import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/admin/pressentation/providers/product_provider.dart';
import 'package:my_project26_fixed/features/cart/cart_provider.dart';
import 'package:my_project26_fixed/features/cart/domain/cart_model.dart';
import 'package:my_project26_fixed/features/dasboard/presentation/widgets/food_card.dart';

class PopularFoodSection extends ConsumerWidget {
  const PopularFoodSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final products = ref.watch(productStreamProvider);

    return products.when(

      data: (items) {

        return SizedBox(
          height: 320,

          child: ListView.builder(

            scrollDirection: Axis.horizontal,

            itemCount: items.length,

            itemBuilder: (context,index){

              final product = items[index];

              return FoodCard(

                product: product,

                onAddToCart: (){

                  ref
                      .read(cartProvider.notifier)
                      .addToCart(

                        CartModel(

                          productId: product.id,

                          name: product.name,

                          imageUrl: product.imageUrl,

                          price: product.finalPrice,

                          quantity: 1,

                          isSelected: true,
                        ),
                      );
                },
              );
            },
          ),
        );
      },

      loading: () =>
          const Center(
            child: CircularProgressIndicator(),
          ),

      error: (e, s) =>
          Center(
            child: Text(e.toString()),
          ),
    );
  }
}