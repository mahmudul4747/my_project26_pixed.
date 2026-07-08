import 'package:flutter/material.dart';

class PriceDetails extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double discount;

  const PriceDetails({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final total = subtotal + deliveryFee - discount;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [

          _priceRow(
            "Subtotal",
            subtotal,
          ),

          const SizedBox(height: 12),

          _priceRow(
            "Delivery Fee",
            deliveryFee,
          ),

          const SizedBox(height: 12),

          _priceRow(
            "Discount",
            -discount,
            color: Colors.green,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 14,
            ),
            child: Divider(),
          ),

          Row(
            children: [

              const Expanded(
                child: Text(
                  "Grand Total",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [
                      Color(0xFFE53935),
                      Color(0xFFFF9800),
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  "৳ ${total.toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
    String title,
    double value, {
    Color color = Colors.black87,
  }) {
    return Row(
      children: [

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),

        Text(
          value < 0
              ? "- ৳ ${value.abs().toStringAsFixed(0)}"
              : "৳ ${value.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
