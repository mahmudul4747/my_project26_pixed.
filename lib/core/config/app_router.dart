import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:my_project26_fixed/features/admin/data/models/product_model.dart';
import 'package:my_project26_fixed/features/admin/pressentation/pages/add_product_page.dart';
import 'package:my_project26_fixed/features/admin/pressentation/pages/admin_dashboard_page.dart';
import 'package:my_project26_fixed/features/admin/pressentation/pages/edit_product_page.dart';
import 'package:my_project26_fixed/features/admin/pressentation/pages/product_list_page.dart';
import 'package:my_project26_fixed/features/auth/presentation/pages/register_page.dart';
import 'package:my_project26_fixed/features/auth/presentation/pages/login_page.dart';
import 'package:my_project26_fixed/features/cart/domain/cart_model.dart';
import 'package:my_project26_fixed/features/cart/presentation/pages/cart_page.dart';
import 'package:my_project26_fixed/features/checkout/domain/order_model.dart';
import 'package:my_project26_fixed/features/checkout/presentation/pages/order_success_page.dart';
import 'package:my_project26_fixed/features/navigation/presentation/pages/main_navigation_page.dart';
import 'package:my_project26_fixed/features/checkout/presentation/pages/checkout_page.dart';
import 'package:my_project26_fixed/features/orders/pressentation/pages/admin_orders_page.dart';
import 'package:my_project26_fixed/features/orders/pressentation/pages/my_orders_page.dart';
import 'package:my_project26_fixed/features/orders/pressentation/pages/order_details_page.dart';


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
  builder: (context, state) => const MainNavigationPage(),
),

    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardPage(),
    ),
    GoRoute(
      path: '/add-product',
      builder: (context, state) => const AddProductPage(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartPage(),
        ),GoRoute(
      path: '/checkout',
      builder: (context, state) {
        final items = state.extra as List<CartModel>;

    return CheckoutPage(
      items: items,
    );
  },
),
GoRoute(
  path: '/order-success',
  builder: (context, state) => const OrderSuccessPage(),
),
GoRoute(
  path: '/my-orders',
  name: 'my-orders',
  builder: (context, state) => const MyOrdersPage(),
),

GoRoute(
  path: '/order-details',
  name: 'order-details',
  builder: (context, state) {
    final order = state.extra as OrderModel;
    return OrderDetailsPage(order: order);
  },
),
GoRoute(
  path: '/admin-orders',
  name: 'admin-orders',
  builder: (context, state) => const AdminOrdersPage(),
),
GoRoute(
  path: '/edit-product',
  builder: (context, state) {
    final product = state.extra as ProductModel;

    return EditProductPage(
      product: product,
    );
  },
),
GoRoute(
  path: '/products',
  builder: (context, state) =>
      const ProductListPage(),
),
  ],
);