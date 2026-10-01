import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/app/modules/auth/infrastructure/providers/authProvider.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/pages/auth_welcome_page.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/pages/create_user_form.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/pages/forgotPasswordPage.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/pages/loginPage.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/pages/signUpPage.dart';
import 'package:mangueras_sv_entire/app/modules/home/presentation/pages/homePage.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/created_pages/create_brands_form_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/created_pages/create_categories_form_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/created_pages/create_product_form_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/view_pages/view_brands_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/view_pages/view_categories_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/view_pages/view_products_page.dart';
import 'package:mangueras_sv_entire/app/modules/orders/presentation/pages/admin_orders_page.dart';
import 'package:mangueras_sv_entire/app/modules/orders/presentation/pages/my_orders_page.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/pages/shop_cart_page.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/pages/shop_products_page.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/pages/shop_welcome_page.dart';

/// Router único: decide por contexto (auth + rol), sin FLAVOR.
///
/// - Público siempre: `/`, `/shop/*`, `/login`, `/signup`, `/forgot-password`, `/auth`
/// - Requiere login: `/home`, `/my-orders`
/// - Solo admin: `/products`, `/brands`, `/categories`, `/create-*`, `/admin-orders`, `/create-users`
enum AppRouteNames {
  shopWelcome,
  authWelcome,
  login,
  signup,
  forgotPassword,
  home,
  myOrders,
  adminOrders,
  products,
  brands,
  categories,
  createBrands,
  createCategories,
  createProducts,
  createUsers,
  shopProducts,
  shopCart,
}

const _adminOnly = {
  '/products',
  '/brands',
  '/categories',
  '/create-brands',
  '/create-categories',
  '/create-products',
  '/create-users',
  '/admin-orders',
};

const _authRequired = {
  '/home',
  '/my-orders',
  ..._adminOnly,
};

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = AppRouterNotifier(ref);
  return GoRouter(
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: notifier.routes,
  );
});

class AppRouterNotifier extends ChangeNotifier {
  final Ref _ref;
  AppRouterNotifier(this._ref) {
    _ref.listen(authProvider, (_, __) => notifyListeners());
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authProvider);
    final isAuth = authState is AuthStateAuthenticated;
    final isAdmin =
        authState is AuthStateAuthenticated && authState.isAdmin;

    final loc = state.matchedLocation;

    // Autenticado intentando entrar a login/signup -> a home
    if (isAuth && (loc == '/login' || loc == '/signup' || loc == '/auth')) {
      return '/home';
    }

    // No autenticado en ruta protegida -> a login
    if (!isAuth && _authRequired.contains(loc)) {
      return '/login';
    }

    // Cliente en ruta solo-admin -> a home
    if (isAuth && !isAdmin && _adminOnly.contains(loc)) {
      return '/home';
    }

    return null;
  }

  List<RouteBase> get routes => [
        GoRoute(
          path: '/',
          name: AppRouteNames.shopWelcome.name,
          builder: (_, __) => ShopWelcomePage(),
        ),
        GoRoute(
          path: '/auth',
          name: AppRouteNames.authWelcome.name,
          builder: (_, __) => const AuthWelcomePage(),
        ),
        GoRoute(
          path: '/login',
          name: AppRouteNames.login.name,
          builder: (_, __) => const LoginPage(),
        ),
        GoRoute(
          path: '/signup',
          name: AppRouteNames.signup.name,
          builder: (_, __) => const SignupPage(),
        ),
        GoRoute(
          path: '/forgot-password',
          name: AppRouteNames.forgotPassword.name,
          builder: (_, __) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: '/home',
          name: AppRouteNames.home.name,
          builder: (_, __) => const HomePage(),
        ),
        GoRoute(
          path: '/my-orders',
          name: AppRouteNames.myOrders.name,
          builder: (_, __) => const MyOrdersPage(),
        ),
        GoRoute(
          path: '/admin-orders',
          name: AppRouteNames.adminOrders.name,
          builder: (_, __) => const AdminOrdersPage(),
        ),
        GoRoute(
          path: '/products',
          name: AppRouteNames.products.name,
          builder: (_, __) => const ProductsPage(),
        ),
        GoRoute(
          path: '/brands',
          name: AppRouteNames.brands.name,
          builder: (_, __) => const BrandsPage(),
        ),
        GoRoute(
          path: '/categories',
          name: AppRouteNames.categories.name,
          builder: (_, __) => const CategoriesPage(),
        ),
        GoRoute(
          path: '/create-brands',
          name: AppRouteNames.createBrands.name,
          builder: (_, __) => const CreateBrandsFormPage(),
        ),
        GoRoute(
          path: '/create-categories',
          name: AppRouteNames.createCategories.name,
          builder: (_, __) => const CreateCategoriesFormPage(),
        ),
        GoRoute(
          path: '/create-products',
          name: AppRouteNames.createProducts.name,
          builder: (_, __) => const CreateProductsFormPage(),
        ),
        GoRoute(
          path: '/create-users',
          name: AppRouteNames.createUsers.name,
          builder: (_, __) => const CreateUserForm(),
        ),
        GoRoute(
          path: '/shop/products',
          name: AppRouteNames.shopProducts.name,
          builder: (_, __) => ShopProductsPage(),
        ),
        GoRoute(
          path: '/shop/cart',
          name: AppRouteNames.shopCart.name,
          builder: (_, __) => const ShopCartPage(),
        ),
      ];
}
