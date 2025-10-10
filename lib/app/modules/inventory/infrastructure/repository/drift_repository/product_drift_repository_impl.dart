// import 'package:drift/drift.dart';
// import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';
// import 'package:mangueras_sv_entire/app/shared/local_storage/infrastructure/providers/app_local_database.dart';
// import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';

// class ProductDriftRepositoryImpl {
//   final AppLocalDatabase _localDatabase;
//   ProductDriftRepositoryImpl(this._localDatabase);

//   Future<void> createProduct(ProductModel productData) async {
//     try {
//       await _localDatabase
//           .into(_localDatabase.productDriftModel)
//           .insert(
//             ProductDriftModelCompanion.insert(
//               code: productData.code,
//               name: productData.name,
//               description: productData.description != null
//                   ? Value(productData.description!)
//                   : const Value.absent(),
//               price: productData.price,
//               shopQuantity: productData.stockQuantity,
//               brandCategoryId: productData.brandCategoryId,
//               imageUrl: Value(productData.imageUrl),
//               isActive: productData.isActive,
//             ),
//           );
//     } catch (e) {
//       logging.e('Error creating product: $e');
//     }
//   }

//   Future<List<ProductModel>> getAllProducts() async {
//     try {
//       final query = _localDatabase.select(
//         _localDatabase.productDriftModel,
//       )..orderBy([(t) => OrderingTerm(expression: t.name)]);
//       final result = await query.get();
//       return result
//           .map(
//             (e) => ProductModel(
//               code: e.code,
//               name: e.name,
//               description: e.description,
//               price: e.price,
//               stockQuantity: e.shopQuantity,
//               brandCategoryId: e.brandCategoryId,
//               imageUrl: e.imageUrl,
//               isActive: e.isActive,
//             ),
//           )
//           .toList();
//     } catch (e) {
//       logging.e('Error fetching all products: $e');
//       return [];
//     }
//   }

//   //update shop quantity
//   Future<void> updateProductShopQuantity(
//     String code,
//     int newShopQuantity,
//   ) async {
//     try {
//       final query = _localDatabase.update(
//         _localDatabase.productDriftModel,
//       )..where((tbl) => tbl.code.equals(code));
//       await query.write(
//         ProductDriftModelCompanion(shopQuantity: Value(newShopQuantity)),
//       );
//     } catch (e) {
//       logging.e('Error updating product shop quantity: $e');
//     }
//   }

//   //delete
//   Future<void> deleteProduct(String code) async {
//     try {
//       final query = _localDatabase.delete(
//         _localDatabase.productDriftModel,
//       )..where((tbl) => tbl.code.equals(code));
//       await query.go();
//     } catch (e) {
//       logging.e('Error deleting product: $e');
//     }
//   }
// }
