import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/providers/inventory_providers.dart';
import 'package:mangueras_sv_entire/app/modules/shop/infrastructure/providers/shop_providers.dart';

/// Estado de los filtros seleccionados
class ShopFiltersState {
  final Set<String> selectedBrandIds;
  final Set<String> selectedCategoryIds;
  final String searchQuery;

  const ShopFiltersState({
    this.selectedBrandIds = const {},
    this.selectedCategoryIds = const {},
    this.searchQuery = '',
  });

  ShopFiltersState copyWith({
    Set<String>? selectedBrandIds,
    Set<String>? selectedCategoryIds,
    String? searchQuery,
  }) {
    return ShopFiltersState(
      selectedBrandIds: selectedBrandIds ?? this.selectedBrandIds,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Limpia todos los filtros
  ShopFiltersState clearAll() {
    return const ShopFiltersState();
  }

  /// Verifica si hay algún filtro activo
  bool get hasActiveFilters =>
      selectedBrandIds.isNotEmpty ||
      selectedCategoryIds.isNotEmpty ||
      searchQuery.isNotEmpty;
}

/// Notifier para gestionar el estado de filtros
class ShopFiltersNotifier extends Notifier<ShopFiltersState> {
  @override
  ShopFiltersState build() {
    return const ShopFiltersState();
  }

  void toggleBrandFilter(String brandId) {
    final currentBrands = Set<String>.from(state.selectedBrandIds);
    if (currentBrands.contains(brandId)) {
      currentBrands.remove(brandId);
    } else {
      currentBrands.add(brandId);
    }
    state = state.copyWith(selectedBrandIds: currentBrands);
  }

  void toggleCategoryFilter(String categoryId) {
    final currentCategories = Set<String>.from(state.selectedCategoryIds);
    if (currentCategories.contains(categoryId)) {
      currentCategories.remove(categoryId);
    } else {
      currentCategories.add(categoryId);
    }
    state = state.copyWith(selectedCategoryIds: currentCategories);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = state.clearAll();
  }
}

/// Provider del notifier de filtros
final shopFiltersProvider =
    NotifierProvider<ShopFiltersNotifier, ShopFiltersState>(() {
  return ShopFiltersNotifier();
});

// ========== PRODUCTOS FILTRADOS ==========

/// Provider que devuelve productos filtrados según el estado de filtros
final filteredProductsProvider = Provider<AsyncValue<List<ProductModel>>>((ref) {
  final productsAsync = ref.watch(shopProductsProvider);
  final filters = ref.watch(shopFiltersProvider);

  return productsAsync.whenData((products) {
    var filtered = products.where((product) => product.isActive).toList();

    // Filtrar por búsqueda
    if (filters.searchQuery.isNotEmpty) {
      final query = filters.searchQuery.toLowerCase();
      filtered = filtered.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.code.toLowerCase().contains(query);
      }).toList();
    }

    // Filtrar por marca (necesitamos obtener brandCategoryIds)
    if (filters.selectedBrandIds.isNotEmpty) {
      final brandCategoryRepo = ref.watch(inventoryBrandCategoryRepositoryProvider);
      // Por ahora filtramos solo por nombre, idealmente usar brandCategoryId
      filtered = filtered.where((product) {
        // TODO: Mejorar filtrado usando brandCategoryId correctamente
        return true; // Mantener todos por ahora
      }).toList();
    }

    // Filtrar por categoría
    if (filters.selectedCategoryIds.isNotEmpty) {
      // TODO: Implementar filtro por categoría usando brandCategoryId
      filtered = filtered.where((product) {
        return true; // Mantener todos por ahora
      }).toList();
    }

    return filtered;
  });
});

// ========== CONTADORES ==========

/// Provider que cuenta cuántos productos hay por marca
final productsCountByBrandProvider =
    FutureProvider.family<int, String>((ref, brandId) async {
  final productRepository = ref.watch(inventoryProductRepositoryProvider);
  final products = await productRepository.getAllProductsByBrandId(brandId);
  return products.length;
});

/// Provider que cuenta cuántos productos hay por categoría
final productsCountByCategoryProvider =
    FutureProvider.family<int, String>((ref, categoryId) async {
  final productRepository = ref.watch(inventoryProductRepositoryProvider);
  final products =
      await productRepository.getAllProductsByCategoryId(categoryId);
  return products.length;
});
