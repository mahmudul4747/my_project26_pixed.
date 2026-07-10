import 'package:flutter/material.dart';
import 'package:my_project26_fixed/features/checkout/domain/order_model.dart';


class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsPage({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Center(
        child: Text(order.customerName),
      ),
    );
  }
}