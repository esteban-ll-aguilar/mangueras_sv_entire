import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/app/modules/shop/infrastructure/providers/shop_providers.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/widgets/shop_products_page/shop_filters_sidebar.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/widgets/shop_products_page/shop_products_grid.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/widgets/shop_products_page/shop_products_page_appbar.dart';

/// Página principal de productos de la tienda
class ShopProductsPage extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ShopProductsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ShopProductsPage> createState() => _ShopProductsPageState();
}

class _ShopProductsPageState extends ConsumerState<ShopProductsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;
    final isTablet = size.width > 600 && size.width <= 1024;
    final isMobile = size.width <= 600;

    return Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: Colors.white,
      appBar: ShopProductsPageAppbar(
        isDesktop: isDesktop,
        onMenuPressed: () {
          widget.scaffoldKey.currentState?.openEndDrawer();
        },
      ),
      // Drawer para móvil y tablet
      endDrawer: isDesktop 
          ? null 
          : Drawer(
              child: ShopFiltersSidebar(),
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar fijo para desktop
          if (isDesktop)
            SizedBox(
              width: 280,
              child: ShopFiltersSidebar(),
            ),
          // Grid de productos
          Expanded(
            child: ShopProductsGrid(
              isDesktop: isDesktop,
              isTablet: isTablet,
              isMobile: isMobile,
            ),
          ),
        ],
      ),
      // FloatingActionButton para el carrito
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final cartCountAsync = ref.watch(cartItemsCountProvider);
          
          return cartCountAsync.when(
            data: (count) => Stack(
              clipBehavior: Clip.none,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    context.go('/shop/cart');
                  },
                  heroTag: 'cart_fab',
                  tooltip: 'Ver Carrito',
                  backgroundColor: const Color(0xFF1A237E),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                if (count > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Center(
                        child: Text(
                          count.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            loading: () => const FloatingActionButton(
              onPressed: null,
              heroTag: 'cart_fab',
              backgroundColor: Color(0xFF1A237E),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            error: (_, __) => const FloatingActionButton(
              onPressed: null,
              heroTag: 'cart_fab',
              backgroundColor: Colors.grey,
              child: Icon(Icons.error),
            ),
          );
        },
      ),
    );
  }
}
