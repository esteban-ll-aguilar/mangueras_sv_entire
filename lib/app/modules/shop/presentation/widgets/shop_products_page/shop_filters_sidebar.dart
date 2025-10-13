import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/shop/infrastructure/providers/shop_providers.dart';
import 'package:mangueras_sv_entire/app/modules/shop/infrastructure/providers/notifiers/shop_providers_notifiers.dart';

/// Widget del sidebar con filtros de marcas y categorías
class ShopFiltersSidebar extends ConsumerWidget {
  const ShopFiltersSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // _SearchField(),
          //Botones de Acción
          Column(
            children: [
              TextButton.icon(
                onPressed: () {
                },
                icon: const Icon(Icons.home, color: Colors.black87),
                label: const Text('Ir a Inicio', style: TextStyle(color: Colors.black87)),
              ),
              const SizedBox(height: 8),
            ],
          ),
          const SizedBox(height: 24),
          _BrandFilters(),
          const Divider(height: 32),
          _CategoryFilters(),
        ],
      ),
    );
  }
}

/// Campo de búsqueda
class _SearchField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar Marcas o Categorías...',
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: (value) {
        ref.read(shopFiltersProvider.notifier).setSearchQuery(value);
      },
    );
  }
}

/// Sección de filtros por marca
class _BrandFilters extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsAsync = ref.watch(shopBrandsProvider);
    final selectedBrandIds = ref.watch(shopFiltersProvider).selectedBrandIds;

    return brandsAsync.when(
      data: (brands) {
        // Mostrar solo las primeras 4 marcas por defecto
        final visibleBrands = brands.take(4).toList();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FilterSectionHeader(
              title: 'Marcas',
              count: brands.length,
            ),
            const SizedBox(height: 12),
            ...visibleBrands.map((brand) {
              final isSelected = selectedBrandIds.contains(brand.id);
              return CheckboxListTile(
                value: isSelected,
                onChanged: (value) {
                  ref
                      .read(shopFiltersProvider.notifier)
                      .toggleBrandFilter(brand.id);
                },
                title: Text(brand.name),
                contentPadding: EdgeInsets.zero,
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
              );
            }).toList(),
            if (brands.length > 4)
              TextButton(
                onPressed: () {
                  // TODO: Mostrar todas las marcas en un dialog
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: EdgeInsets.zero,
                ),
                child: const Text('Ver más'),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

/// Sección de filtros por categoría
class _CategoryFilters extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(shopCategoriesProvider);
    final selectedCategoryIds =
        ref.watch(shopFiltersProvider).selectedCategoryIds;

    return categoriesAsync.when(
      data: (categories) {
        // Filtrar solo categorías principales
        final mainCategories =
            categories.where((c) => c.isMainCategory).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FilterSectionHeader(
              title: 'Categorías',
              count: mainCategories.length,
            ),
            const SizedBox(height: 12),
            ...mainCategories.map((category) {
              final isSelected = selectedCategoryIds.contains(category.id);
              return _CategoryItem(
                category: category.name,
                categoryId: category.id,
                isSelected: isSelected,
                onTap: () {
                  ref
                      .read(shopFiltersProvider.notifier)
                      .toggleCategoryFilter(category.id);
                },
              );
            }).toList(),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

/// Header de sección de filtros
class _FilterSectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _FilterSectionHeader({
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          '($count)',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

/// Item de categoría con checkbox visual
class _CategoryItem extends StatelessWidget {
  final String category;
  final String categoryId;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.category,
    required this.categoryId,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? Colors.red : null,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                category,
                style: TextStyle(
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.red : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
