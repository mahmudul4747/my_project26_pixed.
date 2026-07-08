import 'package:flutter/material.dart';

class PaymentCard extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onChanged;

  const PaymentCard({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Payment Method",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 15),

          _paymentTile(
            icon: Icons.money,
            title: "Cash on Delivery",
            value: "COD",
          ),

          _paymentTile(
            icon: Icons.account_balance_wallet,
            title: "bKash",
            value: "bKash",
          ),

          _paymentTile(
            icon: Icons.credit_card,
            title: "Card",
            value: "Card",
          ),
        ],
      ),
    );
  }

  Widget _paymentTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return RadioListTile<String>(
      value: value,
      groupValue: selectedMethod,
      activeColor: const Color(0xFFE53935),
      onChanged: (v) {
        if (v != null) {
          onChanged(v);
        }
      },
      secondary: Icon(
        icon,
        color: const Color(0xFFE53935),
      ),
      title: Text(title),
      contentPadding: EdgeInsets.zero,
    );
  }
}