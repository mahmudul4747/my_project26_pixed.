import 'package:flutter/material.dart';
import 'package:my_project26_fixed/features/menu/presentation/widgets/special_banner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_project26_fixed/features/navigation/providers/navigation_provider.dart';
import 'package:my_project26_fixed/features/admin/pressentation/providers/product_provider.dart';
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

  @override
Widget build(BuildContext context, WidgetRef ref){

    TextEditingController();
final products = ref.watch(productStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      body:  SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            /// Header
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.deepOrange,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
      
                const SizedBox(width: 14),
      
                Expanded(
                  child:Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      _getGreeting(),
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
    ),

    const SizedBox(height: 4),

    const Text(
      "Hi, Food Lover 👋",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    ),
  ],
),
                ),
      
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none,
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 20),
      
            /// Search
            TextField(
  controller: searchController,

  onChanged: (value) {
    setState(() {
      search = value
          .toLowerCase()
          .trim();
    });
  },

  decoration: InputDecoration(
    hintText: "Search food...",
    prefixIcon: const Icon(Icons.search),

    suffixIcon: search.isEmpty
        ? null
        : IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              searchController.clear();

              setState(() {
                search = "";
              });
            },
          ),

    filled: true,
    fillColor: Colors.grey.shade100,

    border: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),
  ),
),
      
            const SizedBox(height: 22),
      
            /// Banner
            const SpecialBanner(),
      
            const SizedBox(height: 24),
      
            /// Categories
            const Text(
              "Categories",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
      
            const SizedBox(height: 15),
      
            SizedBox(
  height: 95,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: categories.length,
    itemBuilder: (context, index) {
      return _CategoryItem(
        "🍽",
        categories[index],
      );
    },
  ),
),
      
           const SizedBox(height: 28),
      
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      const Text(
        "Popular Foods",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      
      InkWell(
        onTap: () {
          ref
              .read(navigationIndexProvider.notifier)
              .changeIndex(1);
        },
        child: const Text(
          "See All",
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
        ],
      ),
      
      const SizedBox(height: 18),
      final categories = products.when(
  data: (items) {
    final list = items
        .map((e) => e.category)
        .toSet()
        .toList();

    return list;
  },
  loading: () => <String>[],
  error: (_, __) => <String>[],
);
      
      products.when(
        data: (items) {
      if (items.isEmpty) {
        return const SizedBox();
      }
      
      final filtered = items.where((item) {
  return item.name
          .toLowerCase()
          .contains(search) ||
      item.category
          .toLowerCase()
          .contains(search);
}).toList();

final popular = filtered.take(5).toList();
if (popular.isEmpty) {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(40),
      child: Text(
        "No food found",
        style: TextStyle(fontSize: 18),
      ),
    ),
  );
}
      
      return SizedBox(
        height: 240,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: popular.length,
          itemBuilder: (context, index) {
            final product = popular[index];
      
            return Container(
              width: 180,
              margin: const EdgeInsets.only(right: 16),
      
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 15,
                  ),
                ],
              ),
      
              child: Column(
                children: [
      
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: product.imageUrl.trim().isEmpty
    ? const Center(
        child: Icon(
          Icons.fastfood,
          size: 60,
        ),
      )
    : Image.network(
        product.imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const Center(
            child: Icon(
              Icons.fastfood,
              size: 60,
            ),
          );
        },
      ),
                    ),
                  ),
      
                  Padding(
                    padding: const EdgeInsets.all(12),
      
                    child: Column(
                      children: [
      
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
      
                        const SizedBox(height: 6),
      
                        Text(
                          product.category,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
      
                        const SizedBox(height: 8),
      
                        Text(
                          "৳ ${product.finalPrice.toStringAsFixed(0)}",
                          style: const TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
        },
      
        loading: () => const Center(
      child: CircularProgressIndicator(),
        ),
      
        error: (e, _) => Center(
      child: Text(e.toString()),
        ),
      ),
          ],
        ),
      ),
    );
  }
}
String _getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return "Good Morning";
  }

  if (hour < 17) {
    return "Good Afternoon";
  }

  if (hour < 21) {
    return "Good Evening";
  }

  return "Good Night";
}

class _CategoryItem extends StatelessWidget {
  final String emoji;
  final String title;

  const _CategoryItem(
    this.emoji,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor:
                Colors.orange.shade100,
            child: Text(
              emoji,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }
}
