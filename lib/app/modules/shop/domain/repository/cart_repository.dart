import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';
import 'package:mangueras_sv_entire/app/modules/shop/domain/models/cart_item_model.dart';

abstract class CartRepository {
  /// Obtiene todos los items del carrito
  Future<List<CartItemModel>> getAllCartItems();

  /// Agrega un producto al carrito o actualiza la cantidad si ya existe
  Future<void> addToCart({
    required ProductModel product,
    required int quantity,
    String? brandName,
    String? categoryName,
  });

  /// Actualiza la cantidad de un item en el carrito
  Future<void> updateCartItemQuantity(String productCode, int newQuantity);

  /// Elimina un item del carrito
  Future<void> removeFromCart(String productCode);

  /// Limpia todo el carrito
  Future<void> clearCart();

  /// Obtiene la cantidad total de items en el carrito
  Future<int> getCartItemsCount();

  /// Obtiene el total del carrito
  Future<double> getCartTotal();
}
