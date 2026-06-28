import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:mangueras_sv_entire/app/modules/shop/domain/models/drift_models/shop_drift_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';
import 'connection/connection.dart';
part 'app_local_database.g.dart';


@DriftDatabase(
  tables: [CartItemDriftModel],
  include: {
    'queries/functions.drift',
    'queries/indexs.drift',
    'queries/triggers.drift',
  },
)
class AppLocalDatabase extends _$AppLocalDatabase {
  AppLocalDatabase([QueryExecutor? e]) : super(
    e ??
    driftDatabase(
      name: 'local_database',
      native:  const DriftNativeOptions(
        databaseDirectory:  getApplicationSupportDirectory,
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
        onResult: (result) {
          if (result.missingFeatures.isNotEmpty){
            logging.i(
              'Using ${result.chosenImplementation} due to supported'
              'browser features: ${result.missingFeatures}'
            );
          }
        }
      ),
    )        
  );

  AppLocalDatabase.forTesting(DatabaseConnection super.connection);
  @override
  int get schemaVersion => 1;
}
