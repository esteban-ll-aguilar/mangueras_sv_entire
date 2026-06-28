import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';
import 'package:mangueras_sv_entire/app/modules/shop/domain/models/cart_item_model.dart';
import 'package:mangueras_sv_entire/app/modules/shop/domain/repository/cart_repository.dart';
import 'package:mangueras_sv_entire/database/local_database/app_local_database.dart';
import 'package:drift/drift.dart';

/// Implementación del repositorio de carrito usando Drift
class CartDriftRepositoryImpl implements CartRepository {
  final AppLocalDatabase _database;

  CartDriftRepositoryImpl(this._database);

  @override
  Future<List<CartItemModel>> getAllCartItems() async {
    final items = await _database.select(_database.cartItemDriftModel).get();

    return items.map((item) {
      return CartItemModel(
        productCode: item.productCode,
        productName: item.productName,
        productImageUrl: item.productImageUrl,
        productPrice: item.productPrice,
        quantity: item.quantity,
        brandName: item.brandName,
        categoryName: item.categoryName,
        addedAt: item.addedAt,
      );
    }).toList();
  }

  @override
  Future<void> addToCart({
    required ProductModel product,
    required int quantity,
    String? brandName,
    String? categoryName,
  }) async {
    // Verificar si el producto ya existe en el carrito
    final existingItem = await (_database.select(
      _database.cartItemDriftModel,
    )..where((tbl) => tbl.productCode.equals(product.code))).getSingleOrNull();

    if (existingItem != null) {
      // Si existe, actualizar la cantidad
      await (_database.update(
        _database.cartItemDriftModel,
      )..where((tbl) => tbl.productCode.equals(product.code))).write(
        CartItemDriftModelCompanion(
          quantity: Value(existingItem.quantity + quantity),
        ),
      );
    } else {
      // Si no existe, insertar nuevo item
      await _database
          .into(_database.cartItemDriftModel)
          .insert(
            CartItemDriftModelCompanion.insert(
              productCode: product.code,
              productName: product.name,
              productImageUrl: Value(product.imageUrl),
              productPrice: product.price,
              quantity: quantity,
              brandName: Value(brandName),
              categoryName: Value(categoryName),
            ),
          );
    }
  }

  @override
  Future<void> updateCartItemQuantity(
    String productCode,
    int newQuantity,
  ) async {
    if (newQuantity <= 0) {
      await removeFromCart(productCode);
      return;
    }

    await (_database.update(_database.cartItemDriftModel)
          ..where((tbl) => tbl.productCode.equals(productCode)))
        .write(CartItemDriftModelCompanion(quantity: Value(newQuantity)));
  }

  @override
  Future<void> removeFromCart(String productCode) async {
    await (_database.delete(
      _database.cartItemDriftModel,
    )..where((tbl) => tbl.productCode.equals(productCode))).go();
  }

  @override
  Future<void> clearCart() async {
    await _database.delete(_database.cartItemDriftModel).go();
  }

  @override
  Future<int> getCartItemsCount() async {
    final countExp = _database.cartItemDriftModel.productCode.count();
    final query = _database.selectOnly(_database.cartItemDriftModel)
      ..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  @override
  /// - Obtiene el total del carrito a partir del precio total de cada item
  /// - Si el carrito está vacío, retorna 0.0
  /// - Utiliza una consulta SQL para sumar los precios totales de los items
  /// - Retorna el total como un valor double
  /// - Ejemplo: Si hay 2 items con precios totales de 10.0 y 15.5, retorna 25.5
  Future<double> getCartTotal() async {
    final totalExp = _database.cartItemDriftModel.totalPrice.sum();
    final query = _database.selectOnly(_database.cartItemDriftModel)
      ..addColumns([totalExp]);
    final row = await query.getSingleOrNull();
    final double? total = row?.read(totalExp);
    return total ?? 0.0;
  }
}
