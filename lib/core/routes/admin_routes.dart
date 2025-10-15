import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/app/modules/auth/infrastructure/providers/authProvider.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/pages/auth_welcome_page.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/pages/create_user_form.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/pages/loginPage.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/pages/forgotPasswordPage.dart';
// import 'package:mangueras_sv_entire/app/modules/auth/presentation/pages/signUpPage.dart';
import 'package:mangueras_sv_entire/app/modules/home/presentation/pages/homePage.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/created_pages/create_brands_form_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/created_pages/create_categories_form_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/created_pages/create_product_form_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/view_pages/view_brands_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/view_pages/view_categories_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/view_pages/view_products_page.dart';

enum AdminAppRouterNames {
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
  createUsers
}

final adminRouterProvider = Provider<GoRouter>((ref) {
  final router = AdminRouterNotifier(ref);
  return GoRouter(
    refreshListenable: router,
    redirect: router._redirect,
    routes: router._routes,
  );
});

class AdminRouterNotifier extends ChangeNotifier {
  // Simulated authentication state
  final Ref _ref;

  AdminRouterNotifier(this._ref) {
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
      name: AdminAppRouterNames.welcome.name,
      builder: (context, state) => AuthWelcomePage(),
    ),
    GoRoute(
      path: '/login',
      name: AdminAppRouterNames.login.name,
      builder: (context, state) => const LoginPage(),
    ),
    // GoRoute(
    //   path: '/signup',
    //   name: AdminAppRouterNames.signup.name,
    //   builder: (context, state) => const SignupPage(),
    // ),
    GoRoute(
      path: '/forgot-password',
      name: AdminAppRouterNames.forgotPassword.name,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/home',
      name: AdminAppRouterNames.home.name,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/create-brands',
      name: AdminAppRouterNames.createBrands.name,
      builder: (context, state) => const CreateBrandsFormPage(),
    ),
    GoRoute(
      path: '/create-categories',
      name: AdminAppRouterNames.createCategories.name,
      builder: (context, state) => const CreateCategoriesFormPage(),
    ),
    GoRoute(
      path: '/create-products',
      name: AdminAppRouterNames.createProducts.name,
      builder: (context, state) => const CreateProductsFormPage(),
    ),
    GoRoute(
      path: '/categories',
      name: AdminAppRouterNames.categories.name,
      builder: (context, state) => const CategoriesPage(),
    ),
    GoRoute(
      path: '/brands',
      name: AdminAppRouterNames.brands.name,
      builder: (context, state) => const BrandsPage(),
    ),
    GoRoute(
      path: '/create-users',
      name: AdminAppRouterNames.createUsers.name,
      builder: (context, state) => const CreateUserForm(),
    ),
    GoRoute(
      path: '/products',
      name: AdminAppRouterNames.products.name,
      builder: (context, state) => const ProductsPage(),
    ),
  ];
}
