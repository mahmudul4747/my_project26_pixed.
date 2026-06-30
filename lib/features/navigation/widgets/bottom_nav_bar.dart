import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/navigation/providers/navigation_provider.dart';



class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    return NavigationBar(
      selectedIndex: currentIndex,
      height: 72,
      backgroundColor: Colors.white,
      elevation: 8,
      indicatorColor: Colors.deepOrange.shade100,

      onDestinationSelected: (index) {
        ref
            .read(navigationIndexProvider.notifier)
            .changeIndex(index);
      },

      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: "Home",
        ),

        NavigationDestination(
          icon: Icon(Icons.restaurant_menu_outlined),
          selectedIcon: Icon(Icons.restaurant_menu),
          label: "Menu",
        ),

        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: "Cart",
        ),

        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}