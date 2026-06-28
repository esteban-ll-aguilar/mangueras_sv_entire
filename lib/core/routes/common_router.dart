import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/app/modules/home/presentation/pages/homePage.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/pages/shop_products_page.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/pages/shop_welcome_page.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/pages/shop_cart_page.dart';

enum CommonRouterNames { welcome, home, shopCategories, shopProducts, shopCart }

final commonRouterProvider = Provider<GoRouter>((ref) {
  final router = CommonRouterNotifier();
  return GoRouter(
    refreshListenable: router,
    redirect: router._redirect,
    routes: router._routes,
  );
});

class CommonRouterNotifier extends ChangeNotifier {
  String? _redirect(BuildContext context, GoRouterState state) {
    final currentPath = state.matchedLocation;
    // Si el usuario no está autenticado
    if (!currentPath.startsWith('/shop')) {
      return '/';
    }

    // En todos los demás casos, permitir la navegación
    return null;
  }

  List<RouteBase> get _routes => [
    GoRoute(
      path: '/',
      name: CommonRouterNames.welcome.name,
      builder: (context, state) => ShopWelcomePage(),
    ),

    GoRoute(
      path: '/home',
      name: CommonRouterNames.home.name,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/shop/products',
      name: CommonRouterNames.shopProducts.name,
      builder: (context, state) => ShopProductsPage(),
    ),
    GoRoute(
      path: '/shop/cart',
      name: CommonRouterNames.shopCart.name,
      builder: (context, state) => ShopCartPage(),
    ),
  ];
}
