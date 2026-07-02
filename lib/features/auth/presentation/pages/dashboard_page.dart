import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_project26_fixed/features/admin/pressentation/providers/product_provider.dart';
import 'package:my_project26_fixed/features/cart/cart_provider.dart';
import 'package:my_project26_fixed/features/cart/domain/cart_model.dart';
import 'package:my_project26_fixed/features/menu/presentation/widgets/special_banner.dart';
import 'package:my_project26_fixed/features/navigation/providers/navigation_provider.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState
    extends ConsumerState<DashboardPage> {
  final TextEditingController searchController =
      TextEditingController();

  String search = "";
  String selectedCategory = "All";

  final List<String> categories = const [
    "All",
    "Burger",
    "Pizza",
    "Chicken",
    "Drinks",
    "Dessert",
    "Coffee",
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String _categoryEmoji(String category) {
    switch (category) {
      case "Burger":
        return "🍔";
      case "Pizza":
        return "🍕";
      case "Chicken":
        return "🍗";
      case "Drinks":
        return "🥤";
      case "Dessert":
        return "🍰";
      case "Coffee":
        return "☕";
      default:
        return "🍽";
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// HEADER
        Row(
          children: [

            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xffFF8A00),
                    Color(0xffFF5722),
                  ],
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    _getGreeting(),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,ll
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "Hi, Food Lover 👋",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Stack(
              children: [

                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                  ),
                ),

                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 28),

        /// SEARCH
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 15,
              ),
            ],
          ),
          child: TextField(
            controller: searchController,

            onChanged: (value) {
              setState(() {
                search = value
                    .toLowerCase()
                    .trim();
              });
            },

            decoration: InputDecoration(
              hintText:
                  "Search burger, pizza...",

              border: InputBorder.none,

              prefixIcon: const Icon(
                Icons.search,
                color: Colors.deepOrange,
              ),

              suffixIcon: search.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        searchController.clear();

                        setState(() {
                          search = "";
                        });
                      },
                      icon:
                          const Icon(Icons.close),
                    ),
            ),
          ),
        ),

        const SizedBox(height: 28),

        /// HERO CARD
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [
                Color(0xffFF8A00),
                Color(0xffFF5722),
              ],
            ),
          ),
          child: Stack(
            children: [

              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.fastfood,
                  size: 180,
                  color: Colors.white.withOpacity(.12),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "🔥 TODAY OFFER",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "30% OFF\nAll Fast Food",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const SpecialBanner(),

        const SizedBox(height: 24),
            