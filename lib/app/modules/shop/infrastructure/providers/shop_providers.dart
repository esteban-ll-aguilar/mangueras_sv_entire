import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/shop/infrastructure/repository/shop_drift_repository_impl.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';



final shopDriftRepositoryProvider = FutureProvider<ShopDriftRepositoryImpl>((ref) async {
  final localDatabase = await ref.watch(localDatabaseProvider.future);
  return ShopDriftRepositoryImpl(localDatabase);
});
  

