import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/brand_category_model.dart';
import 'package:mangueras_sv_entire/app/shared/local_storage/infrastructure/providers/app_local_database.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';

class BrandCategoryDriftRepositoryImpl {
  final AppLocalDatabase _localDatabase;
  BrandCategoryDriftRepositoryImpl(this._localDatabase);

  Future<void> createBrandCategory(BrandCategoryModel brandCategory) async {
    try {
      await _localDatabase
          .into(_localDatabase.brandCategoryDriftModel)
          .insert(
            BrandCategoryDriftModelCompanion.insert(
              id: brandCategory.id,
              brandId: brandCategory.brandId,
              categoryId: brandCategory.categoryId,
            ),
          );
    } catch (e) {
      logging.e('Error creating brand-category association: $e');
    }
  }

  Future<List<BrandCategoryModel>> getCategoriesByBrandId(
    String brandId,
  ) async {
    try {
      final query = _localDatabase.select(
        _localDatabase.brandCategoryDriftModel,
      )..where((tbl) => tbl.brandId.equals(brandId));
      final result = await query.get();
      return result
          .map(
            (e) => BrandCategoryModel(
              id: e.id,
              brandId: e.brandId,
              categoryId: e.categoryId,
            ),
          )
          .toList();
    } catch (e) {
      logging.e('Error fetching categories by brand ID: $e');
      return [];
    }
  }

  Future<List<BrandCategoryModel>> getBrandsByCategoryId(
    String categoryId,
  ) async {
    try {
      final query = _localDatabase.select(
        _localDatabase.brandCategoryDriftModel,
      )..where((tbl) => tbl.categoryId.equals(categoryId));
      final result = await query.get();
      return result
          .map(
            (e) => BrandCategoryModel(
              id: e.id,
              brandId: e.brandId,
              categoryId: e.categoryId,
            ),
          )
          .toList();
    } catch (e) {
      logging.e('Error fetching brands by category ID: $e');
      return [];
    }
  }

  Future<void> deleteBrandCategory(String id) async {
    try {
      final query = _localDatabase.delete(
        _localDatabase.brandCategoryDriftModel,
      )..where((tbl) => tbl.id.equals(id));
      await query.go();
    } catch (e) {
      logging.e('Error deleting brand-category association: $e');
    }
  }
}
