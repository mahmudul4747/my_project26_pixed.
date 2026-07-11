import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_project26_fixed/features/checkout/domain/order_model.dart';
import 'status_chip.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({
    super.key,
    required this.order,
  });

  String _formatDate(DateTime date) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final day = date.day.toString().padLeft(2, '0');
    final month = monthNames[date.month - 1];
    final year = date.year;
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$day $month $year • ${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final date = _formatDate(order.createdAt);
    final shortId = order.id.length > 6 ? order.id.substring(0, 6) : order.id;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          context.push(
            '/order-details',
            extra: order,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              /// Header
              Row(
                children: [

                  CircleAvatar(
                    radius: 25,
                    backgroundColor:
                        Colors.orange.shade100,
                    child: const Icon(
                      Icons.receipt_long,
                      color: Colors.deepOrange,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Text(
                          order.customerName,
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          date,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  StatusChip(
                    status: order.status,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Divider(),

              const SizedBox(height: 10),

              Row(
                children: [

                  Icon(
                    Icons.confirmation_number,
                    color: Colors.grey.shade700,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    "Order ID",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const Spacer(),

                  Text("#$shortId",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [

                  Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.grey.shade700,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    "${order.items.length} Items",
                  ),

                  const Spacer(),

                  Text(
                    "৳${order.total.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [

                  Icon(
                    Icons.payment,
                    color: Colors.grey.shade700,
                  ),

                  const SizedBox(width: 8),

                  Text(order.paymentMethod),

                  const Spacer(),

                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}