import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/order_item_model.dart';
import '../../data/order_service.dart';
import '../../domain/order_model.dart';
import '../../../cart/cart_provider.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
 
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {

  static const primaryOrange = Color(0xffff6b00);
  static const lightOrange = Color(0xfffff3e8);
  String paymentMethod = "Cash on Delivery";
   bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final service = OrderService();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {

  if (!_formKey.currentState!.validate()) return;

  final selectedItems =
      ref.read(selectedCartItemsProvider);

  final subtotal =
      ref.read(cartTotalProvider);

  const deliveryFee = 60.0;

  final total = subtotal + deliveryFee;

  try {

    setState(() {
      isLoading = true;
    });
    
    final order = OrderModel(
      customerName:
          nameController.text.trim(),
      phone: phoneController.text.trim(),
      address:
          addressController.text.trim(),
      paymentMethod: paymentMethod,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      status: "Pending",
      createdAt: DateTime.now(),
      items: selectedItems
          .map(
            (e) => OrderItemModel(
              productId: e.productId,
              name: e.name,
              price: e.price,
              quantity: e.quantity,
              imageUrl: e.imageUrl,
            ),
          )
          .toList(),
    );

    await service.placeOrder(order);

    ref
        .read(cartProvider.notifier)
        .removeSelected();

    if (!mounted) return;

    await _showSuccessDialog();

  } finally {

    if (mounted) {

      setState(() {

        isLoading = false;

      });

    }

  }

}
Future<void> _showSuccessDialog() async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      icon: const Icon(
        Icons.check_circle,
        size: 70,
        color: Colors.green,
      ),
      title: const Text("Order Placed!"),
      content: const Text(
        "Your order has been placed successfully.",
      ),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text("Continue"),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
final selectedItems = ref.watch(selectedCartItemsProvider);

print("Cart Items = ${cartItems.length}");
print("Selected Items = ${selectedItems.length}");
print(selectedItems.first.name);

for (final item in cartItems) {
  print("${item.name} -> ${item.isSelected}");
}
    final subtotal = ref.watch(cartTotalProvider);
    const deliveryFee = 60.0;
    final total = subtotal + deliveryFee;

   return Scaffold(
  backgroundColor: const Color(0xffF7F7F7),

  appBar: AppBar(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
   title: Text(
  "Checkout (${selectedItems.length})",

      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  bottomNavigationBar: SafeArea(
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          blurRadius: 15,
          color: Colors.black12,
          offset: Offset(0, -3),
        ),
      ],
    ),
    child: Row(
      children: [

        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              const Text(
                "Total",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              Text(
                "৳ ${total.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: primaryOrange,
                ),
              ),

            ],
          ),
        ),

        SizedBox(
          height: 55,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryOrange,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
            ),

            icon: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                        CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.shopping_bag),

            label: Text(
              isLoading
                  ? "Processing..."
                  : "Place Order",
            ),

            onPressed: isLoading
                ? null
                : _placeOrder,
          ),
        ),

      ],
    ),
  ),
),


      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Customer Information",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: nameController,
             validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter your name";
              }

              if (value.trim().length < 3) {
                return "Enter a valid name";
              }

              return null;
            },
              decoration: InputDecoration(
                labelText: "Customer Name",
                filled: true,
                fillColor: Colors.white,

                prefixIcon: const Icon(
                  Icons.person,
                  color: primaryOrange,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: primaryOrange,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your phone number";
                }

                final phone = value.trim();

                if (!RegExp(r'^01[3-9]\d{8}$').hasMatch(phone)) {
                  return "Enter a valid 11-digit phone number";
                }

                return null;
              },  
            decoration: InputDecoration(
              labelText: "Phone Number",
              filled: true,
              fillColor: Colors.white,

              prefixIcon: const Icon(
                Icons.phone,
                color: primaryOrange,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: primaryOrange,
                  width: 2,
                ),
              ),
            ),
                        ),

            const SizedBox(height: 16),

            TextFormField(
              controller: addressController,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter address";
                }

                return null;

              },
              decoration: InputDecoration(
                labelText: "Delivery Address",

                filled: true,
                fillColor: Colors.white,

                prefixIcon: const Icon(
                  Icons.location_on,
                  color: primaryOrange,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: primaryOrange,
                    width: 2,
                  ),
                ),
              ),

                          ),
            const SizedBox(height: 20),

              const Text(
                "Payment Method",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 12),
            _paymentCard(
              title: "Cash on Delivery",
              subtitle: "Pay after receiving food",
              icon: Icons.payments_outlined,
              value: "Cash on Delivery",
            ),

            _paymentCard(
              title: "Card Payment",
              subtitle: "Visa / MasterCard / bKash",
              icon: Icons.credit_card,
              value: "Card",
            ),

              const SizedBox(height: 20),

            const SizedBox(height: 24),
          const Text(
  "Selected Items",
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: selectedItems.length,
  itemBuilder: (context, index) {
    final item = selectedItems[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: item.imageUrl.isNotEmpty
            ? Image.network(
                item.imageUrl,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.fastfood),
        title: Text(item.name),
        subtitle: Text(
          "${item.quantity} × ৳${item.price}",
        ),
        trailing: Text(
          "৳ ${(item.price * item.quantity).toStringAsFixed(0)}",
        ),
      ),
    );
  },
),

const SizedBox(height: 20),
...selectedItems.map(
  (item) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: item.imageUrl.isNotEmpty
            ? Image.network(
                item.imageUrl,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.fastfood, size: 40),
      ),
      title: Text(
        item.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "${item.quantity} × ৳${item.price.toStringAsFixed(0)}",
      ),
      trailing: Text(
        "৳ ${(item.quantity * item.price).toStringAsFixed(0)}",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryOrange,
        ),
      ),
    ),
  ),
),
const SizedBox(height: 25),

            const Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: lightOrange,
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: primaryOrange,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Text(
                          "${selectedItems.length} Items",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    _buildRow("Subtotal", subtotal),

                    const SizedBox(height: 12),

                    _buildRow("Delivery Fee", deliveryFee),

                    const SizedBox(height: 12),

                    _buildRow("Discount", 0),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(),
                    ),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [

                        const Text(
                          "Grand Total",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "৳ ${total.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryOrange,
                          ),
                        ),

                      ],
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
  Widget _paymentCard({
  required String title,
  required String subtitle,
  required IconData icon,
  required String value,
}) {
  final selected = paymentMethod == value;

  return InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: () {
      setState(() {
        paymentMethod = value;
      });
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selected
            ? lightOrange
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected
              ? primaryOrange
              : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [

          Icon(
            selected
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            color: primaryOrange,
          ),

          const SizedBox(width: 15),

          CircleAvatar(
            radius: 22,
            backgroundColor: lightOrange,
            child: Icon(
              icon,
              color: primaryOrange,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),

              ],
            ),
          ),

          Icon(
            value == "Cash on Delivery"
                ? Icons.payments
                : Icons.verified_user,
            color: primaryOrange,
          ),

        ],
      ),
    ),
  );
}

  Widget _buildRow(
  String title,
  double amount, {
  bool isBold = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 6,
    ),
    child: Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [

        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold
                ? FontWeight.bold
                : FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),

        Text(
          "৳ ${amount.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold
                ? FontWeight.bold
                : FontWeight.w600,
          ),
        ),

      ],
    ),
  );
}
}