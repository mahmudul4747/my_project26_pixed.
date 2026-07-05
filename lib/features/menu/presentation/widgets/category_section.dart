import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/menu/presentation/providers/category_provider.dart';

class CategorySection extends ConsumerStatefulWidget {
  const CategorySection({super.key});

  @override
  ConsumerState<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends ConsumerState<CategorySection> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {
      "title": "All",
      "icon": Icons.restaurant_menu,
    },
    {
      "title": "Burger",
      "icon": Icons.lunch_dining,
    },
    {
      "title": "Pizza",
      "icon": Icons.local_pizza,
    },
    {
      "title": "Drinks",
      "icon": Icons.local_drink,
    },
    {
      "title": "Chicken",
      "icon": Icons.egg_alt,
    },
    {
      "title": "Dessert",
      "icon": Icons.icecream,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Categories",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "See All",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = categories[index];
                final isSelected =
                    selectedIndex == index;

                return InkWell(
                  borderRadius:
                      BorderRadius.circular(18),
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });

                    ref.read(categoryProvider.notifier).state =
                        item["title"] as String;
                  },
                  child: AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xffFF8A00)
                          : Colors.white,
                      borderRadius:
                          BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(.05),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item["icon"],
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item["title"],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.black87,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}