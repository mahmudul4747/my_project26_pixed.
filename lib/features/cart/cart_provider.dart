import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'domain/cart_model.dart';

class CartNotifier extends StateNotifier<List<CartModel>> {
  CartNotifier() : super([]);

  void addToCart(CartModel item) {
    final index = state.indexWhere((e) => e.id == item.id);

    if (index >= 0) {
      state[index].quantity++;
      state = [...state];
    } else {
      state = [...state, item];
    }
  }

  void increaseQty(String id) {
    final index = state.indexWhere((e) => e.id == id);

    if (index >= 0) {
      state[index].quantity++;
      state = [...state];
    }
  }

  void decreaseQty(String id) {
    final index = state.indexWhere((e) => e.id == id);

    if (index >= 0) {
      if (state[index].quantity > 1) {
        state[index].quantity--;
      } else {
        state.removeAt(index);
      }

      state = [...state];
    }
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartModel>>(
  (ref) => CartNotifier(),
);

final cartTotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);

  double total = 0;

  for (final item in cartItems) {
    total += item.price * item.quantity;
  }

  return total;
});