import 'package:flutter/material.dart';

class CheckoutBox extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final VoidCallback onCheckout;

  const CheckoutBox({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final total = subtotal + deliveryFee - discount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _row("Subtotal", subtotal),
            const SizedBox(height: 8),
            _row("Delivery Fee", deliveryFee),
            const Divider(),
            _row("Total", total, bold: true),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCheckout,
                child: const Text("Checkout"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, double value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          "৳ ${value.toStringAsFixed(0)}",
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}