import 'package:flutter/material.dart';
import '../../data/order_service.dart';

class OrderStatusDropdown extends StatefulWidget {
  final String orderId;
  final String currentStatus;

  const OrderStatusDropdown({
    super.key,
    required this.orderId,
    required this.currentStatus,
  });

  @override
  State<OrderStatusDropdown> createState() =>
      _OrderStatusDropdownState();
}

class _OrderStatusDropdownState
    extends State<OrderStatusDropdown> {

  late String selectedStatus;

  final OrderService _service = OrderService();

  final List<String> statuses = const [
    'Pending',
    'Preparing',
    'Ready',
    'Completed',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentStatus;
  }

  Future<void> _changeStatus(String value) async {

    setState(() {
      selectedStatus = value;
    });

    await _service.updateOrderStatus(
      widget.orderId,
      value,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Order updated to $value",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedStatus,
        borderRadius: BorderRadius.circular(12),

        items: statuses.map((status) {

          return DropdownMenuItem(
            value: status,
            child: Text(status),
          );

        }).toList(),

        onChanged: (value) {

          if (value == null) return;

          _changeStatus(value);

        },
      ),
    );
  }
}