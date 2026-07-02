import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_project26_fixed/features/menu/presentation/widgets/dashboard_header.dart';
import 'package:my_project26_fixed/features/menu/presentation/widgets/dashboard_search.dart';
import 'package:my_project26_fixed/features/menu/presentation/widgets/dashboard_banner.dart';
import 'package:my_project26_fixed/features/menu/presentation/widgets/category_section.dart';
import 'package:my_project26_fixed/features/menu/presentation/widgets/popular_food_section.dart';
import 'package:my_project26_fixed/features/menu/presentation/widgets/recommended_section.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // TODO:
            // ref.refresh(productProvider);
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),

            slivers: [
              const SliverToBoxAdapter(
                child: DashboardHeader(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),

              const SliverToBoxAdapter(
                child: DashboardSearch(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),

              const SliverToBoxAdapter(
                child: DashboardBanner(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),

              const SliverToBoxAdapter(
                child: CategorySection(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),

              const SliverToBoxAdapter(
                child: PopularFoodSection(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),

              const SliverToBoxAdapter(
                child: RecommendedSection(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
              const SizedBox(height: 20),

                const DashboardSearch(),

                const SizedBox(height: 20),
                const DashboardBanner(),
                const SizedBox(height: 24),

                    CategorySection(),

                const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}