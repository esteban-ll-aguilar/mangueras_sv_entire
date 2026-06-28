import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/repository/brand_category_repository.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/repository/inventory_storage_repository.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/repository/product_repository.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/repository/brand_category_repository_impl.dart';
// import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/repository/drift_repository/inventory_drift_impl.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/repository/inventory_storage_repository_impl.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/repository/product_repository_impl.dart';
// import 'package:mangueras_sv_entire/database/local_database/app_local_database.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';


final inventoryBrandCategoryRepositoryProvider = Provider<BrandCategoryRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return BrandCategoryRepositoryImpl(supabase);
});



final inventoryProductRepositoryProvider = Provider<ProductRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return ProductRepositoryImpl(supabase);
});


// final inventoryDriftRepositoryProvider = FutureProvider<InventoryDriftRepositoryImpl>((ref) async {
//   final localDatabase = await ref.watch(localDatabaseProvider.future);
//   return InventoryDriftRepositoryImpl(localDatabase);
// });
  

final inventoryStorageRepositoryProvider = Provider<InventoryStorageRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return InventoryStorageRepositoryImpl('inventory-images', supabase);
});