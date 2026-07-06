import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/navigation/providers/navigation_provider.dart';
import 'package:my_project26_fixed/features/cart/cart_provider.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final cartItems = ref.watch(cartProvider);

    return NavigationBar(
      selectedIndex: currentIndex,
      height: 72,
      backgroundColor: Colors.white,
      elevation: 8,
      indicatorColor: Colors.deepOrange.shade100,

      onDestinationSelected: (index) {
        ref.read(navigationIndexProvider.notifier).changeIndex(index);
      },

      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: "Home",
        ),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: cartItems.isNotEmpty,
            label: Text(cartItems.length.toString()),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          selectedIcon: Badge(
            isLabelVisible: cartItems.isNotEmpty,
            label: Text(cartItems.length.toString()),
            child: const Icon(Icons.shopping_cart),
          ),
          label: "Cart",
        ),
                const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: "Orders",
          ),

        

        const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}