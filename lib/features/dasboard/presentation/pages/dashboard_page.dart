import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/admin/pressentation/providers/product_provider.dart';
import 'package:my_project26_fixed/features/dasboard/presentation/widgets/category_section.dart';
import 'package:my_project26_fixed/features/dasboard/presentation/widgets/dashboard_banner.dart';
import 'package:my_project26_fixed/features/dasboard/presentation/widgets/dashboard_search.dart';
import 'package:my_project26_fixed/features/dasboard/presentation/widgets/recommended_section.dart';
import 'package:go_router/go_router.dart';
import 'package:my_project26_fixed/features/cart/cart_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      floatingActionButton: Consumer(
  builder: (context, ref, _) {
    final cartItems = ref.watch(cartProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        FloatingActionButton(
          backgroundColor: const Color(0xffFF8A00),
          onPressed: () {
            context.push('/cart');
          },
          child: const Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
        ),

        if (cartItems.isNotEmpty)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  cartItems.length.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  },
),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(productStreamProvider);
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: const [
          

              SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),

              SliverToBoxAdapter(
                child: DashboardSearch(),
              ),

              SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),

              SliverToBoxAdapter(
                child: DashboardBanner(),
              ),

              SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),

              SliverToBoxAdapter(
                child: CategorySection(),
              ),

              SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),

             /* SliverToBoxAdapter(
                child: PopularFoodSection(),
              ),*/

              SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),

              SliverToBoxAdapter(
                child: RecommendedSection(),
              ),

              SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
            ],
          ),
        ),
      ),
    );
  }
}