import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/checkout/domain/order_model.dart';
import '../../providers/order_provider.dart';
import '../widgets/order_card.dart';

class MyOrdersPage extends ConsumerWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("Please login first"),
        ),
      );
    }

    final ordersAsync = ref.watch(userOrdersProvider(user.uid));

    return Scaffold(
      backgroundColor: const Color(0xffF8F9FD),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        title: const Text(
          "My Orders",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ordersAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (e, s) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              e.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        data: (orders) {
          if (orders.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(userOrdersProvider(user.uid));
              },
              child: ListView(
                children: const [
                  SizedBox(height: 140),

                  Icon(
                    Icons.receipt_long_outlined,
                    size: 90,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 20),

                  Center(
                    child: Text(
                      "No Orders Yet",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  Center(
                    child: Text(
                      "Your placed orders will appear here.",
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userOrdersProvider(user.uid));
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 20,
              ),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final OrderModel order = orders[index];

                return OrderCard(
                  order: order,
                );
              },
            ),
          );
        },
      ),
    );
  }
}