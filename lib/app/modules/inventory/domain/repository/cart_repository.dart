import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';

/// Modelo para un item del carrito
class CartItem {
  final String productCode;
  final String productName;
  final String? productImageUrl;
  final double productPrice;
  final int quantity;
  final String? brandName;
  final String? categoryName;
  final DateTime addedAt;

  CartItem({
    required this.productCode,
    required this.productName,
    this.productImageUrl,
    required this.productPrice,
    required this.quantity,
    this.brandName,
    this.categoryName,
    required this.addedAt,
  });

  double get total => productPrice * quantity;

  CartItem copyWith({
    String? productCode,
    String? productName,
    String? productImageUrl,
    double? productPrice,
    int? quantity,
    String? brandName,
    String? categoryName,
    DateTime? addedAt,
  }) {
    return CartItem(
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
      brandName: brandName ?? this.brandName,
      categoryName: categoryName ?? this.categoryName,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}

/// Repositorio para gestionar el carrito de compras local
abstract class CartRepository {
  /// Obtiene todos los items del carrito
  Future<List<CartItem>> getAllCartItems();

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
