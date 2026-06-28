import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/brand_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/category_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/providers/inventory_providers.dart';
import 'package:mangueras_sv_entire/app/modules/shop/domain/models/cart_item_model.dart';
import 'package:mangueras_sv_entire/app/modules/shop/domain/repository/cart_repository.dart';
import 'package:mangueras_sv_entire/app/modules/shop/infrastructure/providers/notifiers/shop_providers_notifiers.dart';
import 'package:mangueras_sv_entire/app/modules/shop/infrastructure/repository/drift_repository/cart_drift_repository_impl.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';

/// Provider del repositorio de carrito usando base de datos local
final cartRepositoryProvider = FutureProvider<CartRepository>((ref) async {
  final database = await ref.watch(localDatabaseProvider.future);
  return CartDriftRepositoryImpl(database);
});

/// Provider que obtiene todos los items del carrito
final cartItemsProvider = StreamProvider<List<CartItemModel>>((ref) async* {
  final repository = await ref.watch(cartRepositoryProvider.future);

  // Emitir items iniciales
  yield await repository.getAllCartItems();

  // Escuchar cambios (por ahora, recargar cada segundo para simular stream)
  // En producción, Drift tiene watch() que emite streams automáticamente
  await for (var _ in Stream.periodic(const Duration(milliseconds: 500))) {
    yield await repository.getAllCartItems();
  }
});

/// Provider que obtiene el contador de items en el carrito
final cartItemsCountProvider = FutureProvider<int>((ref) async {
  final repository = await ref.watch(cartRepositoryProvider.future);
  return await repository.getCartItemsCount();
});

/// Provider que obtiene el total del carrito
final cartTotalProvider = FutureProvider<double>((ref) async {
  final repository = await ref.watch(cartRepositoryProvider.future);
  return await repository.getCartTotal();
});

/// Provider para obtener todas las marcas
final shopBrandsProvider = FutureProvider<List<BrandModel>>((ref) async {
  final brandCategoryRepository = ref.watch(
    inventoryBrandCategoryRepositoryProvider,
  );
  return await brandCategoryRepository.getAllBrands();
});

/// Provider para obtener todas las categorías
final shopCategoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final brandCategoryRepository = ref.watch(
    inventoryBrandCategoryRepositoryProvider,
  );
  return await brandCategoryRepository.getAllCategories();
});

/// Provider del notifier de filtros
final shopFiltersProvider =
    NotifierProvider<ShopFiltersNotifier, ShopFiltersState>(() {
      return ShopFiltersNotifier();
    });

// ========== PRODUCTOS FILTRADOS ==========

/// Provider que devuelve productos filtrados según el estado de filtros
final filteredProductsProvider = FutureProvider<List<ProductModel>>((
  ref,
) async {
  final productsAsync = ref.watch(inventoryProductRepositoryProvider);
  final filters = ref.watch(shopFiltersProvider);

  try {
    final products = await productsAsync.getAllFilteredProducts(
      productName: filters.searchQuery.isNotEmpty ? filters.searchQuery : null,
      brandIds: filters.selectedBrandIds.isNotEmpty
          ? filters.selectedBrandIds
          : null,
      categoryIds: filters.selectedCategoryIds.isNotEmpty
          ? filters.selectedCategoryIds
          : null,
      isActive: true, // Solo productos activos
    );
    return products;
  } catch (e) {
    logging.i('Error fetching filtered products: $e');
    return [];
  }
});

// ========== CONTADORES ==========

/// Provider que cuenta cuántos productos hay por marca
final productsCountByBrandProvider = FutureProvider.family<int, String>((
  ref,
  brandId,
) async {
  final productRepository = ref.watch(inventoryProductRepositoryProvider);
  final products = await productRepository.getAllProductsByBrandId(brandId);
  return products.length;
});

/// Provider que cuenta cuántos productos hay por categoría
final productsCountByCategoryProvider = FutureProvider.family<int, String>((
  ref,
  categoryId,
) async {
  final productRepository = ref.watch(inventoryProductRepositoryProvider);
  final products = await productRepository.getAllProductsByCategoryId(
    categoryId,
  );
  return products.length;
});
