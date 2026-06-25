import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:my_project26_fixed/features/admin/pressentation/pages/add_product_page.dart';
import 'package:my_project26_fixed/features/admin/pressentation/pages/admin_dashboard_page.dart';
import 'package:my_project26_fixed/features/auth/presentation/pages/home_page.dart';
import 'package:my_project26_fixed/features/auth/presentation/pages/register_page.dart';
import 'package:my_project26_fixed/features/auth/presentation/pages/login_page.dart';
import 'package:my_project26_fixed/features/cart/presentation/pages/cart_page.dart';
import 'package:my_project26_fixed/features/menu/presentation/pages/menu_page.dart';
import 'package:my_project26_fixed/features/orders/presentation/pages/checkout_page.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/login',

  redirect: (context, state) {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    if (state.matchedLocation != '/login' &&
        state.matchedLocation != '/register') {
      return '/login';
    }
    return null;
  }

  return null;
},

  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),

    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardPage(),
    ),
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuPage(),
    ),GoRoute(
      path: '/add-product',
      builder: (context, state) => const AddProductPage(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartPage(),
    ),GoRoute(
          path: '/checkout',
          builder: (context, state) =>
              const CheckoutPage(),
        ),
  ],
);