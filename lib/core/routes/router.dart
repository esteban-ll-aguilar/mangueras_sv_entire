import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/app/modules/auth/infrastructure/providers/authProvider.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/pages/create_user_form.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/pages/loginPage.dart';
// import 'package:mangueras_sv_entire/app/modules/auth/presentation/pages/signUpPage.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/pages/forgotPasswordPage.dart';
import 'package:mangueras_sv_entire/app/modules/home/presentation/pages/homePage.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/inventory/pages/created_pages/create_brands_form_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/inventory/pages/created_pages/create_categories_form_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/inventory/pages/created_pages/create_product_form_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/inventory/pages/view_pages/view_brands_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/inventory/pages/view_pages/view_categories_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/shop/pages/a.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/shop/pages/shop_products_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/shop/pages/shop_welcome_page.dart';

enum AppRouterNames {
  login,
  signup,
  welcome,
  home,
  forgotPassword,
  createBrands,
  createCategories,
  createProducts,
  products,
  categories,
  shopCategories,
  brands,
  createUsers,
  shopProducts,
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);
  return GoRouter(
    refreshListenable: router,
    redirect: router._redirect,
    routes: router._routes,
  );
});

class RouterNotifier extends ChangeNotifier {
  // Simulated authentication state
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(authProvider, (_, __) => notifyListeners());
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authProvider);
    final isAuth = switch (authState) {
      AuthStateAuthenticated() => true,
      _ => false,
    };

    final currentPath = state.matchedLocation;

    // Si el usuario está autenticado y está en páginas de auth, redirigir a home
    if (isAuth &&
        (currentPath == '/' || currentPath == '/login'
        // ||
        // currentPath == '/signup'
        )) {
      return '/home';
    }

    // Si el usuario no está autenticado
    if (!isAuth &&
        currentPath != '/' &&
        currentPath != '/login' &&
        // currentPath != '/signup' &&
        currentPath != '/forgot-password' &&
        !currentPath.startsWith('/shop')
        ) {
      return '/';
    }

    // En todos los demás casos, permitir la navegación
    return null;
  }

  List<RouteBase> get _routes => [
    GoRoute(
      path: '/',
      name: AppRouterNames.welcome.name,
      builder: (context, state) => ShopWelcomePage(),
    ),
    GoRoute(
      path: '/login',
      name: AppRouterNames.login.name,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: AppRouterNames.forgotPassword.name,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/home',
      name: AppRouterNames.home.name,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/create-brands',
      name: AppRouterNames.createBrands.name,
      builder: (context, state) => const CreateBrandsFormPage(),
    ),
    GoRoute(
      path: '/create-categories',
      name: AppRouterNames.createCategories.name,
      builder: (context, state) => const CreateCategoriesFormPage(),
    ),
    GoRoute(
      path: '/create-products',
      name: AppRouterNames.createProducts.name,
      builder: (context, state) => const CreateProductsFormPage(),
    ),
    GoRoute(
      path: '/categories',
      name: AppRouterNames.categories.name,
      builder: (context, state) => const CategoriesPage(),
    ),
    GoRoute(
      path: '/brands',
      name: AppRouterNames.brands.name,
      builder: (context, state) => const BrandsPage(),
    ),
    GoRoute(
      path: '/create-users',
      name: AppRouterNames.createUsers.name,
      builder: (context, state) => const CreateUserForm(),
    ),
    GoRoute(
      path: '/shop/products',
      name: AppRouterNames.shopProducts.name,
      builder: (context, state) => ShopProductsPage(),
    ),
    GoRoute(
      path: '/shop/help',
      name: AppRouterNames.shopCategories.name,
      builder: (context, state) => ProductsPage(),
    ),
  ];
}
