import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/cart/domain/cart_model.dart';

class CartNotifier extends StateNotifier<List<CartModel>> {
  CartNotifier() : super([]);

  void addToCart(CartModel item) {
    final index = state.indexWhere((e) => e.id == item.id);

    if (index != -1) {
      state[index].quantity++;
      state = [...state];
    } else {
      state = [...state, item];
    }
  }

  void increaseQty(String id) {
    final index = state.indexWhere((e) => e.id == id);

    if (index != -1) {
      state[index].quantity++;
      state = [...state];
    }
  }

  void decreaseQty(String id) {
    final index = state.indexWhere((e) => e.id == id);

    if (index != -1) {
      if (state[index].quantity > 1) {
        state[index].quantity--;
        state = [...state];
      } else {
        removeItem(id);
      }
    }
  }

  void removeItem(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  double get totalPrice {
    return state.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
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
  final cart = ref.watch(cartProvider);

  return cart.fold(
    0,
    (sum, item) => sum + item.price * item.quantity,
  );
});