import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_project26_fixed/features/admin/presentation/providers/admin_dashboard_provider.dart';

import '../providers/product_provider.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(
  title: const Text('Admin Dashboard'),
  centerTitle: true,
  actions: [
    IconButton(
      tooltip: 'Logout',
      icon: const Icon(Icons.logout),
      onPressed: () async {
        await FirebaseAuth.instance.signOut();

        if (context.mounted) {
          context.go('/login');
        }
      },
    ),
  ],
),
      body: dashboard.when(
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dashboardStatsProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _card(
                  "Products",
                  data.totalProducts.toString(),
                  Icons.fastfood,
                  Colors.orange,
                ),
                _card(
                  "Categories",
                  data.totalCategories.toString(),
                  Icons.category,
                  Colors.blue,
                ),
                _card(
                  "Orders",
                  data.totalOrders.toString(),
                  Icons.shopping_bag,
                  Colors.green,
                ),
                _card(
                  "Revenue",
                  "৳${data.totalRevenue.toStringAsFixed(2)}",
                  Icons.attach_money,
                  Colors.red,
                ),
                const SizedBox(height: 25),

                ElevatedButton.icon(
                  onPressed: () {
                    context.push('/admin/products');
                  },
                  icon: const Icon(Icons.inventory),
                  label: const Text("Manage Products"),
                ),

                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: () {
                    context.push('/admin/orders');
                  },
                  icon: const Icon(Icons.receipt_long),
                  label: const Text("Manage Orders"),
                ),

                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: () {
                    context.push('/add-category');
                  },
                  icon: const Icon(Icons.category),
                  label: const Text("Categories"),
                ),
              ],
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(e.toString()),
        ),
      ),
    );
  }

  Widget _card(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}