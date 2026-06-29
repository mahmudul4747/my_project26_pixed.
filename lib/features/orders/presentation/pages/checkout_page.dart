import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/order_service.dart';
import '../../domain/order_model.dart';
import '../../../cart/cart_provider.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
 
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  String paymentMethod = "Cash on Delivery";
   bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final service = OrderService();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = ref.watch(cartTotalProvider);
    const deliveryFee = 60.0;
    final total = subtotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Customer Information",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: nameController,
             validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter your name";
              }

              if (value.trim().length < 3) {
                return "Enter a valid name";
              }

              return null;
            },
              decoration: const InputDecoration(
                labelText: "Customer Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your phone number";
                }

                final phone = value.trim();

                if (!RegExp(r'^01[3-9]\d{8}$').hasMatch(phone)) {
                  return "Enter a valid 11-digit phone number";
                }

                return null;
              },  
            decoration: const InputDecoration(
                labelText: "Phone Number",
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: addressController,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter address";
                }

                return null;

              },
              decoration: const InputDecoration(
                labelText: "Delivery Address",
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

              const Text(
                "Payment Method",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              RadioListTile<String>(
                title: const Text("Cash on Delivery"),
                value: "Cash on Delivery",
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value!;
                  });
                },
              ),

              RadioListTile<String>(
                title: const Text("Card"),
                value: "Card",
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

            const SizedBox(height: 24),

            const Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildRow("Subtotal", subtotal),
                    const SizedBox(height: 10),
                    _buildRow("Delivery Fee", deliveryFee),
                    const Divider(height: 25),
                    _buildRow(
                      "Total",
                      total,
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart_checkout),
                label:  isLoading
    ? const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
    : const Text(
        "Place Order",
        style: TextStyle(fontSize: 18),
      ),
               onPressed: isLoading
    ? null
    : () async {
        if (!_formKey.currentState!.validate()) return;

        try {
          setState(() {
            isLoading = true;
          });

          final order = OrderModel(
            customerName: nameController.text.trim(),
            phone: phoneController.text.trim(),
            address: addressController.text.trim(),
            paymentMethod: paymentMethod,
            subtotal: subtotal,
            deliveryFee: deliveryFee,
            total: total,
            status: "Pending",
            createdAt: DateTime.now(),
          );

          await service.placeOrder(order);

          ref.read(cartProvider.notifier).removeSelected();

          if (!mounted) return;

          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
  icon: const Icon(
    Icons.check_circle,
    color: Colors.green,
    size: 70,
  ),
  title: const Text("Order Successful"),
              content: const Text(
                "Thank you!\nYour order has been placed successfully.",
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );

          if (!mounted) return;
          Navigator.pop(context);

        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        } finally {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        }
      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          "৳ ${amount.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}