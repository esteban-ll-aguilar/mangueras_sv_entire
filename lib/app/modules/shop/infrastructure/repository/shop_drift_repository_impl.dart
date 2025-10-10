import 'package:mangueras_sv_entire/app/modules/shop/domain/repositories/drift_repository/cart_drift_repository_impl.dart';
import 'package:mangueras_sv_entire/database/local_database/app_local_database.dart';

class ShopDriftRepositoryImpl {
  final AppLocalDatabase _localDatabase;

  late final CartDriftRepositoryImpl cartRepository =
      CartDriftRepositoryImpl(_localDatabase);

  ShopDriftRepositoryImpl(this._localDatabase);
}
