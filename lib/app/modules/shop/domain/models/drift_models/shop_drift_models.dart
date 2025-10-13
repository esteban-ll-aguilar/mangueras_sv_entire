
import 'package:drift/drift.dart';

/// Tabla para items del carrito de compras local
@DataClassName('cart_item_drift_model')
class CartItemDriftModel extends Table {
  TextColumn get productCode => text()(); // Referencia al producto
  TextColumn get productName => text()();
  TextColumn get productImageUrl => text().nullable()();
  RealColumn get productPrice => real()();
  IntColumn get quantity => integer()();
  TextColumn get brandName => text().nullable()();
  TextColumn get categoryName => text().nullable()();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
  RealColumn get totalPrice => real().generatedAs(productPrice * quantity.cast<double>())();

  @override
  Set<Column> get primaryKey => {productCode};

  // @override
  // List<String> get customConstraints => [
  //   'CREATE INDEX IF NOT EXISTS idx_cart_item_product_code ON cart_item_drift_model(productCode)',
  // ];
}
