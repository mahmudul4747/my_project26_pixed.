import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/orders/providers/order_provider.dart';
import '../widgets/admin_order_card.dart';

class AdminOrdersPage extends ConsumerStatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  ConsumerState<AdminOrdersPage> createState() =>
      _AdminOrdersPageState();
}

class _AdminOrdersPageState
    extends ConsumerState<AdminOrdersPage> {
  final TextEditingController _searchController =
      TextEditingController();

  String _search = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(allOrdersProvider);
    await Future.delayed(
      const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(allOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Admin Orders",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

          /// Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText:
                    "Search customer / phone / order id",
                prefixIcon:
                    const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _search =
                      value.trim().toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: ordersAsync.when(

              loading: () => const Center(
                child:
                    CircularProgressIndicator(),
              ),

              error: (e, s) => Center(
                child: Text(
                  e.toString(),
                ),
              ),

              data: (orders) {

                final filtered = orders.where((order) {

                  return order.customerName
                          .toLowerCase()
                          .contains(_search) ||

                      order.phone
                          .toLowerCase()
                          .contains(_search) ||

                      order.id
                          .toLowerCase()
                          .contains(_search);

                }).toList();

                if (filtered.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      children: const [

                        SizedBox(height: 120),

                        Icon(
                          Icons.receipt_long,
                          size: 90,
                          color: Colors.grey,
                        ),

                        SizedBox(height: 20),

                        Center(
                          child: Text(
                            "No Orders Found",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refresh,

                  child: ListView.builder(
                    padding:
                        const EdgeInsets.all(16),

                    itemCount:
                        filtered.length,

                    itemBuilder:
                        (context, index) {

                      return AdminOrderCard(
                        order: filtered[index],
                      );

                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}