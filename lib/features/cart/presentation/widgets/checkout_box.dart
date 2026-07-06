import 'package:flutter/material.dart';

class CheckoutBox extends StatelessWidget {
  final double totalPrice;
  final VoidCallback? onCheckout;

  const CheckoutBox({
    super.key,
    required this.totalPrice,
    this.onCheckout,
  });

  static const _primaryRed = Color(0xFFE53935);
  static const _primaryOrange = Color(0xFFFF9800);

  @override
  Widget build(BuildContext context) {
    const deliveryFee = 50.0;
    const discount = 0.0;

    final grandTotal = totalPrice + deliveryFee - discount;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            _priceRow(
              "Subtotal",
              totalPrice,
            ),

            const SizedBox(height: 4),

            _priceRow(
              "Delivery Fee",
              deliveryFee,
            ),

            const SizedBox(height: 4),

            _priceRow(
              "Discount",
              -discount,
              valueColor: Colors.green,
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),

            _priceRow(
              "Grand Total",
              grandTotal,
              isBold: true,
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [
                      _primaryRed,
                      _primaryOrange,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: onCheckout ??
                      () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Checkout Coming Soon",
                            ),
                          ),
                        );
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    "Checkout  ৳${grandTotal.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(
    String title,
    double amount, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isBold ? 18 : 15,
            fontWeight: isBold
                ? FontWeight.bold
                : FontWeight.w500,
          ),
        ),
        Text(
          "৳${amount.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: isBold ? 18 : 15,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}