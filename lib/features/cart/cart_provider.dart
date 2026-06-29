import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'domain/cart_model.dart';

class CartNotifier extends StateNotifier<List<CartModel>> {
  CartNotifier() : super([]);

  void addToCart(CartModel item) {
  final index =
      state.indexWhere((e) => e.productId == item.productId);

  if (index >= 0) {
    final updated = state[index].copyWith(
      quantity: state[index].quantity + item.quantity,
    );

    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) updated else state[i],
    ];
  } else {
    state = [...state, item];
  }
}
  void increaseQty(String productId) {
    state = state.map((item) {
      if (item.productId == productId) {
        return item.copyWith(
          quantity: item.quantity + 1,
        );
      }
      return item;
    }).toList();
  }

  void decreaseQty(String productId) {
    state = state
        .map((item) {
          if (item.productId == productId) {
            if (item.quantity > 1) {
              return item.copyWith(
                quantity: item.quantity - 1,
              );
            }
          }
          return item;
        })
        .where((item) =>
            !(item.productId == productId &&
                item.quantity == 1))
        .toList();
  }

  void toggleSelection(String productId) {
    state = state.map((item) {
      if (item.productId == productId) {
        return item.copyWith(
          isSelected: !item.isSelected,
        );
      }
      return item;
    }).toList();
  }

  void selectAll() {
    state = state
        .map((item) => item.copyWith(isSelected: true))
        .toList();
  }

  void unselectAll() {
    state = state
        .map((item) => item.copyWith(isSelected: false))
        .toList();
  }

  void removeSelected() {
    state = state
        .where((item) => !item.isSelected)
        .toList();
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
  final items = ref.watch(cartProvider);

  return items
      .where((e) => e.isSelected)
      .fold(
        0,
        (sum, item) =>
            sum + item.price * item.quantity,
      );
});

final selectedCartItemsProvider =
    Provider<List<CartModel>>((ref) {
  return ref
      .watch(cartProvider)
      .where((e) => e.isSelected)
      .toList();
});

final selectedItemCountProvider =
    Provider<int>((ref) {
  return ref
      .watch(cartProvider)
      .where((e) => e.isSelected)
      .length;
});