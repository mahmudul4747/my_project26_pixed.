import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [

              const SizedBox(height: 30),

              const Text(
                "Order Placed Successfully!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Thank you for your order.\nYour food is being prepared.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

Container(
  height: 130,
  width: 130,
  decoration: const BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(
      colors: [
        Color(0xFFE53935),
        Color(0xFFFF9800),
      ],
    ),
  ),
  child:const Icon(
  Icons.check_circle,
  size: 120,
  color: Colors.green,
),
),

const SizedBox(height: 50),

SizedBox(
  width: double.infinity,
  height: 58,
  child: DecoratedBox(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0xFFE53935),
          Color(0xFFFF9800),
        ],
      ),
      borderRadius: BorderRadius.circular(18),
    ),
    child: ElevatedButton(
      onPressed: () {
        context.go('/home');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: const Text(
        "Back to Home",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
),

            ],
          ),
        ),
      ),
    );
  }
}