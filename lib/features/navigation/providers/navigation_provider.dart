import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom Navigation Selected Index
final navigationIndexProvider =
    StateNotifierProvider<NavigationNotifier, int>(
  (ref) => NavigationNotifier(),
);

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void changeIndex(int index) {
    state = index;
  }
}