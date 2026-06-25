import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/order_service.dart';
import '../../domain/order_model.dart';
import '../../../cart/cart_provider.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() =>
      _CheckoutPageState();
}

class _CheckoutPageState
    extends ConsumerState<CheckoutPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final service = OrderService();

  @override
  Widget build(BuildContext context) {
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
              ),
            ),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: "Address",
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Total: ৳ ${total.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final order = OrderModel(
                  customerName:
                      nameController.text,
                  phone:
                      phoneController.text,
                  address:
                      addressController.text,
                  total: total,
                  createdAt: DateTime.now(),
                );

                await service.placeOrder(order);

                ref
                    .read(cartProvider.notifier)
                    .clearCart();

                if (!mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Order Placed Successfully",
                    ),
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text(
                "Place Order",
              ),
            ),
          ],
        ),
      ),
    );
  }
}