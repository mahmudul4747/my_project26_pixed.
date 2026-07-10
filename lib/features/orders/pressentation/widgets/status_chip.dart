import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({
    super.key,
    required this.status,
  });

  Color get color {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;

      case "accepted":
        return Colors.blue;

      case "preparing":
        return Colors.deepPurple;

      case "on the way":
        return Colors.teal;

      case "delivered":
        return Colors.green;

      case "cancelled":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (status.toLowerCase()) {
      case "pending":
        return Icons.schedule;

      case "accepted":
        return Icons.check_circle;

      case "preparing":
        return Icons.restaurant;

      case "on the way":
        return Icons.delivery_dining;

      case "delivered":
        return Icons.done_all;

      case "cancelled":
        return Icons.cancel;

      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}