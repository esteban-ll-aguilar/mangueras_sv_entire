import 'package:drift/drift.dart';
import 'package:drift/web.dart';

import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/drift_models/inventory_drift_models.dart';

part 'app_local_database_web.g.dart';

@DriftDatabase(tables: [
  ProductDriftModel,
  BrandDriftModel,
  CategoryDriftModel,
  BrandCategoryDriftModel
])
class AppLocalDatabase extends _$AppLocalDatabase {
  AppLocalDatabase._internal(QueryExecutor e) : super(e);

  static Future<AppLocalDatabase> create() async {
    final db = WebDatabase('local_database');
    return AppLocalDatabase._internal(db);
  }

  @override
  int get schemaVersion => 1;
}
