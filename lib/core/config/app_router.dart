import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'package:my_project26_fixed/features/admin/data/models/product_model.dart';
import 'package:my_project26_fixed/features/admin/presentation/pages/add_product_page.dart';
import 'package:my_project26_fixed/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:my_project26_fixed/features/admin/presentation/pages/edit_product_page.dart';
import 'package:my_project26_fixed/features/admin/presentation/pages/product_list_page.dart';
import 'package:my_project26_fixed/features/auth/presentation/pages/login_page.dart';
import 'package:my_project26_fixed/features/auth/presentation/pages/onboarding_page.dart';
import 'package:my_project26_fixed/features/auth/presentation/pages/register_page.dart';

import 'package:my_project26_fixed/features/cart/domain/cart_model.dart';
import 'package:my_project26_fixed/features/cart/presentation/pages/cart_page.dart';
import 'package:my_project26_fixed/features/category/presentation/pages/add_category_page.dart';

import 'package:my_project26_fixed/features/checkout/domain/order_model.dart';
import 'package:my_project26_fixed/features/checkout/presentation/pages/checkout_page.dart';
import 'package:my_project26_fixed/features/checkout/presentation/pages/order_success_page.dart';

import 'package:my_project26_fixed/features/navigation/presentation/pages/main_navigation_page.dart';

import 'package:my_project26_fixed/features/orders/pressentation/pages/admin_orders_page.dart';
import 'package:my_project26_fixed/features/orders/pressentation/pages/my_orders_page.dart';
import 'package:my_project26_fixed/features/orders/pressentation/pages/order_details_page.dart';

import 'package:my_project26_fixed/features/profile/domain/user_profile_model.dart';
import 'package:my_project26_fixed/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:my_project26_fixed/features/profile/presentation/pages/profile_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',

  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;

    final publicPages =
    state.matchedLocation == '/onboarding' ||
    state.matchedLocation == '/login' ||
    state.matchedLocation == '/register';

if (user == null) {
  return publicPages ? null : '/login';
}

if (state.matchedLocation == '/onboarding' ||
    state.matchedLocation == '/login' ||
    state.matchedLocation == '/register') {
  return '/home';
}
    return null;
  },

  routes: [

    /// ================= AUTH =================
   GoRoute(
  path: '/onboarding',
  builder: (context, state) => const OnboardingPage(),
),

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),

    /// ================= HOME =================

    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) =>
          const MainNavigationPage(),
    ),

    /// ================= CART =================

    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) =>
          const CartPage(),
    ),

    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) {

        final items =
            state.extra as List<CartModel>;

        return CheckoutPage(
          items: items,
        );
      },
    ),

    GoRoute(
      path: '/order-success',
      name: 'order-success',
      builder: (context, state) =>
          const OrderSuccessPage(),
    ),

    /// ================= USER ORDERS =================

    GoRoute(
      path: '/my-orders',
      name: 'my-orders',
      builder: (context, state) =>
          const MyOrdersPage(),
    ),

    GoRoute(
      path: '/order-details',
      name: 'order-details',
      builder: (context, state) {

        final order =
            state.extra as OrderModel;

        return OrderDetailsPage(
          order: order,
        );
      },
    ),

    /// ================= PROFILE =================

    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) =>
          const ProfilePage(),
    ),

    GoRoute(
      path: '/edit-profile',
      name: 'edit-profile',
      builder: (context, state) {

        final user =
            state.extra as UserProfileModel;

        return EditProfilePage(
          user: user,
        );
      },
    ),
/// ================= ADMIN =================

GoRoute(
  path: '/admin',
  name: 'admin',
  builder: (context, state) => const AdminDashboardPage(),
),

GoRoute(
  path: '/admin/products',
  name: 'admin-products',
  builder: (context, state) => const ProductListPage(),
),

GoRoute(
  path: '/admin/orders',
  name: 'admin-orders',
  builder: (context, state) => const AdminOrdersPage(),
),

GoRoute(
  path: '/admin/add-product',
  name: 'admin-add-product',
  builder: (context, state) => const AddProductPage(),
),

GoRoute(
  path: '/admin/edit-product',
  name: 'admin-edit-product',
  builder: (context, state) {
    final product = state.extra as ProductModel;

    return EditProductPage(product: product);
  },
),
    GoRoute(
  path: '/add-category',
  name: 'add-category',
  builder: (context, state) =>
      const AddCategoryPage(),
),
  ],
);