import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/drift_models/inventory_drift_models.dart';

part 'app_local_database_native.g.dart';

@DriftDatabase(tables: [
  ProductDriftModel,
  BrandDriftModel,
  CategoryDriftModel,
  BrandCategoryDriftModel
])
class AppLocalDatabase extends _$AppLocalDatabase {
  AppLocalDatabase._internal(QueryExecutor e) : super(e);

  static Future<AppLocalDatabase> create() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'local_database.sqlite'));
    final db = NativeDatabase(file);
    return AppLocalDatabase._internal(db);
  }

  @override
  int get schemaVersion => 1;
}
