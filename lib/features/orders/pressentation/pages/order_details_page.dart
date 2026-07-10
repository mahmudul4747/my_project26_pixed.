import 'package:flutter/material.dart';
import 'package:my_project26_fixed/features/checkout/domain/order_model.dart';
import '../widgets/status_chip.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsPage({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final date = _formatDate(order.createdAt);

    return Scaffold(
      backgroundColor: const Color(0xffF8F9FD),
      appBar: AppBar(
        title: const Text("Order Details"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Header
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor:
                              Colors.orange.shade100,
                          child: const Icon(
                            Icons.receipt_long,
                            color: Colors.deepOrange,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.customerName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(date),
                            ],
                          ),
                        ),
                        StatusChip(
                          status: order.status,
                        ),
                      ],
                    ),

                    const Divider(height: 30),

                    _infoTile(
                      Icons.phone,
                      "Phone",
                      order.phone,
                    ),

                    _infoTile(
                      Icons.location_on,
                      "Address",
                      order.address,
                    ),

                    _infoTile(
                      Icons.payment,
                      "Payment",
                      order.paymentMethod,
                    ),

                    if (order.note.isNotEmpty)
                      _infoTile(
                        Icons.note,
                        "Note",
                        order.note,
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// Items
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    const Row(
                      children: [
                        Icon(Icons.shopping_bag),
                        SizedBox(width: 8),
                        Text(
                          "Ordered Items",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    ...order.items.map(
                      (item) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(10),
                          child: Image.network(
                            item.imageUrl,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) =>
                                    Container(
                              width: 55,
                              height: 55,
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.fastfood,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                        subtitle:
                            Text("Qty : ${item.quantity}"),
                        trailing: Text(
                          "৳${(item.price * item.quantity).toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// Bill
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    _priceRow(
                      "Subtotal",
                      order.subtotal,
                    ),

                    _priceRow(
                      "Delivery Fee",
                      order.deliveryFee,
                    ),

                    _priceRow(
                      "Discount",
                      -order.discount,
                    ),

                    const Divider(),

                    _priceRow(
                      "Grand Total",
                      order.total,
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic value) {
    if (value == null) return '';
    DateTime? dt;
    if (value is DateTime) {
      dt = value;
    } else if (value is String) {
      dt = DateTime.tryParse(value);
    }
    if (dt == null) return value.toString();
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  Widget _infoTile(
      IconData icon,
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(icon,
              color: Colors.deepOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
      String title,
      double price, {
        bool isBold = false,
      }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: isBold ? 18 : 15,
            ),
          ),
          const Spacer(),
          Text(
            "৳${price.toStringAsFixed(0)}",
            style: TextStyle(
              fontWeight: isBold
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: isBold ? 18 : 15,
              color: isBold
                  ? Colors.deepOrange
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}