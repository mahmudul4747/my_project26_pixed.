import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_project26_fixed/features/navigation/providers/navigation_provider.dart';


import 'package:my_project26_fixed/features/auth/presentation/pages/dashboard_page.dart';
import 'package:my_project26_fixed/features/menu/presentation/pages/menu_page.dart';
import 'package:my_project26_fixed/features/cart/presentation/pages/cart_page.dart';
import 'package:my_project26_fixed/features/navigation/widgets/bottom_nav_bar.dart';
import 'package:my_project26_fixed/features/wishlist/presentation/pages/settings_page.dart';

class MainNavigationPage extends ConsumerWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navigationIndexProvider);

    final pages = [
      const DashboardPage(),
      const MenuPage(),
      const CartPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: pages,
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}