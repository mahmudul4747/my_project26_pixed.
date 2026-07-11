import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_project26_fixed/features/cart/presentation/pages/cart_page.dart';
import 'package:my_project26_fixed/features/dasboard/presentation/pages/dashboard_page.dart';
import 'package:my_project26_fixed/features/navigation/providers/navigation_provider.dart';
import 'package:my_project26_fixed/features/navigation/widgets/bottom_nav_bar.dart';
import 'package:my_project26_fixed/features/orders/pressentation/pages/my_orders_page.dart';
import 'package:my_project26_fixed/features/profile/presentation/pages/profile_page.dart';

class MainNavigationPage extends ConsumerWidget {
  const MainNavigationPage({super.key});

  static const List<Widget> _pages = [
    DashboardPage(),
    CartPage(),
    MyOrdersPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navigationIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: _pages,
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}