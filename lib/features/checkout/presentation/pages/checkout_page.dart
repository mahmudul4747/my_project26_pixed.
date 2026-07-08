import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_project26_fixed/features/cart/cart_provider.dart';

import 'package:my_project26_fixed/features/cart/domain/cart_model.dart';
import 'package:my_project26_fixed/features/checkout/presentation/pages/order_success_page.dart';
import 'package:my_project26_fixed/features/checkout/presentation/widgets/address_card.dart';
import 'package:my_project26_fixed/features/checkout/presentation/widgets/order_summary.dart';
import 'package:my_project26_fixed/features/checkout/presentation/widgets/payment_card.dart';
import 'package:my_project26_fixed/features/checkout/presentation/widgets/price_details.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  
  
  final List<CartModel> items;

  const CheckoutPage({
    super.key,
    
    required this.items,
  });

  @override
  ConsumerState<CheckoutPage> createState() =>
      _CheckoutPageState();
}

class _CheckoutPageState
    extends ConsumerState<CheckoutPage> {
  static const Color primaryRed =
      Color(0xFFE53935);
      String paymentMethod = "COD";

  static const Color primaryOrange =
      Color(0xFFFF9800);
bool isPlacingOrder = false;
final nameController = TextEditingController();

final phoneController = TextEditingController();

final addressController = TextEditingController();

final noteController = TextEditingController();

final formKey = GlobalKey<FormState>();

@override
void dispose() {
  nameController.dispose();
  phoneController.dispose();
  addressController.dispose();
  noteController.dispose();
  super.dispose();
}
Future<void> _placeOrder() async {
  if (!formKey.currentState!.validate()) {
    return;
  }

  if (widget.items.isEmpty) {
    return;
  }

  // Total Calculate
  final subtotal = widget.items.fold<double>(
    0,
    (sum, item) => sum + (item.price * item.quantity),
  );

  const deliveryFee = 50.0;
  const discount = 0.0;

  // Order Data
  final order = {
    "customerName": nameController.text,
    "phone": phoneController.text,
    "address": addressController.text,
    "note": noteController.text,
    "paymentMethod": paymentMethod,
    "items": widget.items.map((e) {
      return {
        "name": e.name,
        "price": e.price,
        "quantity": e.quantity,
      };
    }).toList(),
    "subtotal": subtotal,
    "deliveryFee": deliveryFee,
    "discount": discount,
    "total": subtotal + deliveryFee - discount,
    "status": "Pending",
    "createdAt": FieldValue.serverTimestamp(),
  };

  setState(() {
    isPlacingOrder = true;
  });

  try {
    // Step 7: Firestore Save
    ref.read(cartProvider.notifier).clearCart();

    if (!mounted) return;

Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => const OrderSuccessPage(),
  ),
);
    // FirebaseFirestore.instance.collection('orders').add(order);

    await FirebaseFirestore.instance
    .collection('orders')
    .add(order);

    // Success Page
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  } finally {
    if (mounted) {
      setState(() {
        isPlacingOrder = false;
      });
    }
  }
}
  @override
  Widget build(BuildContext context) {
    final subtotal = widget.items.fold<double>(
  0,
  (sum, item) => sum + (item.price * item.quantity),
);

const deliveryFee = 50.0;
const discount = 0.0;

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryRed,
                  primaryOrange,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: Row(
                  children: [

                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Expanded(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Checkout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          Text(
                            "Complete your order",
                            style: TextStyle(
                              color:
                                  Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding:
                          const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius:
                            BorderRadius.circular(
                                15),
                      ),
                      child: Text(
                        "${widget.items.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// Step 2
              /// Address Card
              AddressCard(
                    title: "Home",
                    address:
                        "House 12, Road 5, Mirpur, Dhaka",
                    onChange: () {
                      // পরে Address Page-এ Navigate করবে
                    },
                  ),    
                  Form(
  key: formKey,
  child: Column(
    children: [

      TextFormField(
        controller: nameController,
        decoration: const InputDecoration(
          labelText: "Full Name",
          prefixIcon: Icon(Icons.person),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter your name";
          }
          return null;
        },
      ),

      const SizedBox(height: 15),

      TextFormField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          labelText: "Phone Number",
          prefixIcon: Icon(Icons.phone),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter phone number";
          }
          return null;
        },
      ),

      const SizedBox(height: 15),

      TextFormField(
        controller: addressController,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: "Delivery Address",
          prefixIcon: Icon(Icons.location_on),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter address";
          }
          return null;
        },
      ),

      const SizedBox(height: 15),

      TextFormField(
        controller: noteController,
        maxLines: 2,
        decoration: const InputDecoration(
          labelText: "Order Note (Optional)",
          prefixIcon: Icon(Icons.note),
        ),
      ),
    ],
  ),
),              

              const SizedBox(height: 15),

              /// Step 3
              /// Payment Card
              PaymentCard(
                    selectedMethod: paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value;
                      });
                    },
                  ),

              const SizedBox(height: 15),

              /// Step 4
              /// Order Summary
              OrderSummary(
                  items: widget.items,
                ),
              const SizedBox(height: 15),

              /// Step 5
              /// Price Details
              PriceDetails(
                  subtotal: subtotal,
                  deliveryFee: deliveryFee,
                  discount: discount,
                ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 58,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    primaryOrange,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                          18),
                ),
              ),
              onPressed: isPlacingOrder
                  ? null
                  : _placeOrder,
              child: isPlacingOrder
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "PLACE ORDER",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}