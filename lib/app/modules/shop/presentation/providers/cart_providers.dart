import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';
import 'package:mangueras_sv_entire/app/modules/shop/infrastructure/providers/shop_providers.dart';

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
