import 'package:drift/drift.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/brand_model.dart';
import 'package:mangueras_sv_entire/app/shared/local_storage/infrastructure/providers/app_local_database.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';

class BrandDriftRepositoryImpl {
  final AppLocalDatabase _localDatabase;
  BrandDriftRepositoryImpl(this._localDatabase);

  Future<BrandModel?> createBrand(BrandModel brandData) async {
    try {
      await _localDatabase
          .into(_localDatabase.brandDriftModel)
          .insert(
            BrandDriftModelCompanion.insert(
              id: brandData.id,
              name: brandData.name,
              description: brandData.description != null
                  ? Value(brandData.description!)
                  : const Value.absent(),
              imageUrl: Value(brandData.imageUrl),
            ),
          );
      return brandData;
    } catch (e) {
      logging.e('Error creating brand: $e');
      return null;
    }
  }

  Future<List<BrandModel>> getAllBrands() async {
    try {
      final query = _localDatabase.select(
        _localDatabase.brandDriftModel,
      )..orderBy([(t) => OrderingTerm(expression: t.name)]);
      final result = await query.get();
      return result
          .map(
            (e) => BrandModel(
              id: e.id,
              name: e.name,
              description: e.description,
              imageUrl: e.imageUrl,
            ),
          )
          .toList();
    } catch (e) {
      logging.e('Error fetching all brands: $e');
      return [];
    }
  }

  Future<BrandModel?> getBrandById(String id) async {
    try {
      final query = _localDatabase.select(
        _localDatabase.brandDriftModel,
      )..where((tbl) => tbl.id.equals(id));
      final result = await query.getSingleOrNull();
      if (result == null) return null;
      return BrandModel(
        id: result.id,
        name: result.name,
        description: result.description,
        imageUrl: result.imageUrl,
      );
    } catch (e) {
      logging.e('Error fetching brand by ID: $e');
      return null;
    }
  }

  Future<List<BrandModel>> getBrandsByName(String name) async {
    try {
      final query =
          _localDatabase.select(
              _localDatabase.brandDriftModel,
            )
            ..where((tbl) => tbl.name.like('%$name%'))
            ..orderBy([(t) => OrderingTerm(expression: t.name)]);
      final result = await query.get();
      return result
          .map(
            (e) => BrandModel(
              id: e.id,
              name: e.name,
              description: e.description,
              imageUrl: e.imageUrl,
            ),
          )
          .toList();
    } catch (e) {
      logging.e('Error fetching brands by name: $e');
      return [];
    }
  }
}
