import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/providers/cart_providers.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/providers/shop_providers.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/widgets/shop_products_page/shop_product_card.dart';

/// Widget del grid de productos con filtros aplicados
class ShopProductsGrid extends ConsumerWidget {
  final bool isDesktop;
  final bool isTablet;
  final bool isMobile;

  const ShopProductsGrid({
    Key? key,
    required this.isDesktop,
    required this.isTablet,
    required this.isMobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProductsAsync = ref.watch(filteredProductsProvider);
    final filters = ref.watch(shopFiltersProvider);

    return Column(
      children: [
        _ProductsToolbar(
          isDesktop: isDesktop,
          isMobile: isMobile,
          hasActiveFilters: filters.hasActiveFilters,
          onClearFilters: () {
            ref.read(shopFiltersProvider.notifier).clearFilters();
          },
        ),
        Expanded(
          child: filteredProductsAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return _EmptyState();
              }

              final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ShopProductCard(
                    product: product,
                    onAddToCart: (quantity) async {
                      // Agregar al carrito local
                      await ref.read(cartActionsProvider.notifier).addToCart(
                            product: product,
                            quantity: quantity,
                          );
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$quantity x ${product.name} agregado al carrito'),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'Ver carrito',
                              onPressed: () {
                                // TODO: Navegar a página del carrito
                              },
                            ),
                          ),
                        );
                      }
                    },
                    onToggleFavorite: () {
                      // TODO: Toggle favorito
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _ErrorState(error: error.toString()),
          ),
        ),
      ],
    );
  }
}

/// Barra de herramientas sobre el grid
class _ProductsToolbar extends StatelessWidget {
  final bool isDesktop;
  final bool isMobile;
  final bool hasActiveFilters;
  final VoidCallback onClearFilters;

  const _ProductsToolbar({
    required this.isDesktop,
    required this.isMobile,
    required this.hasActiveFilters,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final filteredProductsAsync =
                    ref.watch(filteredProductsProvider);
                return filteredProductsAsync.when(
                  data: (products) => Text(
                    'Todos los productos (${products.length} productos)',
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  loading: () => const Text('Cargando productos...'),
                  error: (_, __) => const Text('Error al cargar productos'),
                );
              },
            ),
          ),
          if (!isMobile)
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    // TODO: Implementar ordenamiento
                  },
                  icon: const Icon(Icons.sort, size: 20),
                  label: const Text('Ordenar'),
                ),
                const SizedBox(width: 8),
                if (hasActiveFilters)
                  TextButton(
                    onPressed: onClearFilters,
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Limpiar filtros'),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Estado vacío cuando no hay productos
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron productos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta ajustar tus filtros de búsqueda',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

/// Estado de error
class _ErrorState extends StatelessWidget {
  final String error;

  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar productos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
