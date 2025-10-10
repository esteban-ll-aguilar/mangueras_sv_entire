import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/repository/cart_repository.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/repository/drift_repository/cart_drift_repository_impl.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';

// ========== PROVIDER DEL REPOSITORIO ==========

/// Provider del repositorio de carrito usando base de datos local
final cartRepositoryProvider = FutureProvider<CartRepository>((ref) async {
  final database = await ref.watch(localDatabaseProvider.future);
  return CartDriftRepositoryImpl(database);
});

// ========== PROVIDERS DE DATOS ==========

/// Provider que obtiene todos los items del carrito
final cartItemsProvider = StreamProvider<List<CartItem>>((ref) async* {
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

// ========== NOTIFIER PARA ACCIONES DEL CARRITO ==========

/// Notifier para realizar acciones en el carrito
class CartActionsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // No se necesita estado inicial
  }

  /// Agrega un producto al carrito
  Future<void> addToCart({
    required ProductModel product,
    required int quantity,
    String? brandName,
    String? categoryName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(cartRepositoryProvider.future);
      await repository.addToCart(
        product: product,
        quantity: quantity,
        brandName: brandName,
        categoryName: categoryName,
      );
      // Invalidar providers para refrescar datos
      ref.invalidate(cartItemsProvider);
      ref.invalidate(cartItemsCountProvider);
      ref.invalidate(cartTotalProvider);
    });
  }

  /// Actualiza la cantidad de un item en el carrito
  Future<void> updateQuantity(String productCode, int newQuantity) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(cartRepositoryProvider.future);
      await repository.updateCartItemQuantity(productCode, newQuantity);
      // Invalidar providers para refrescar datos
      ref.invalidate(cartItemsProvider);
      ref.invalidate(cartItemsCountProvider);
      ref.invalidate(cartTotalProvider);
    });
  }

  /// Elimina un item del carrito
  Future<void> removeItem(String productCode) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(cartRepositoryProvider.future);
      await repository.removeFromCart(productCode);
      // Invalidar providers para refrescar datos
      ref.invalidate(cartItemsProvider);
      ref.invalidate(cartItemsCountProvider);
      ref.invalidate(cartTotalProvider);
    });
  }

  /// Limpia todo el carrito
  Future<void> clearCart() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(cartRepositoryProvider.future);
      await repository.clearCart();
      // Invalidar providers para refrescar datos
      ref.invalidate(cartItemsProvider);
      ref.invalidate(cartItemsCountProvider);
      ref.invalidate(cartTotalProvider);
    });
  }
}

/// Provider del notifier de acciones del carrito
final cartActionsProvider = AsyncNotifierProvider<CartActionsNotifier, void>(() {
  return CartActionsNotifier();
});
