import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_project26_fixed/features/checkout/domain/order_model.dart';
import 'order_status_dropdown.dart';
import 'status_chip.dart';

class AdminOrderCard extends StatelessWidget {
  final OrderModel order;

  const AdminOrderCard({
    super.key,
    required this.order,
  });

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Header
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.orange.shade100,
                  child: const Icon(
                    Icons.shopping_bag,
                    color: Colors.orange,
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
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        order.phone,
                        style: const TextStyle(
                          color: Colors.grey,
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

            _infoRow(
              Icons.location_on,
              order.address,
            ),

            const SizedBox(height: 10),

            _infoRow(
              Icons.payment,
              order.paymentMethod,
            ),

            const SizedBox(height: 10),

            _infoRow(
              Icons.calendar_today,
              _formatDate(order.createdAt),
            ),

            const Divider(height: 28),

            Row(
              children: [

                Expanded(
                  child: _summaryBox(
                    "Items",
                    "${order.items.length}",
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _summaryBox(
                    "Total",
                    "৳${order.total.toStringAsFixed(0)}",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Update Status",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            OrderStatusDropdown(
              orderId: order.id,
              currentStatus: order.status,
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  context.push(
                    '/order-details',
                    extra: order,
                  );
                },
                icon: const Icon(Icons.visibility),
                label: const Text(
                  "View Details",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryBox(
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(title),
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String text,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }
}