import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = true;

    await Future.delayed(
      const Duration(seconds: 2),
    );

    state = false;
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, bool>(
  (ref) => AuthNotifier(),
);