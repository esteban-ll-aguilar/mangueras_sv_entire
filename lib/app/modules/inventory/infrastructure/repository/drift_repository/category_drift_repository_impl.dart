import 'package:drift/drift.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/category_model.dart';
import 'package:mangueras_sv_entire/app/shared/local_storage/infrastructure/providers/app_local_database.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';

class CategoryDriftRepositoryImpl {
  final AppLocalDatabase _localDatabase;
  CategoryDriftRepositoryImpl(this._localDatabase);

  Future<CategoryModel?> createCategory(CategoryModel categoryData) async {
    try {
      await _localDatabase
          .into(_localDatabase.categoryDriftModel)
          .insert(
            CategoryDriftModelCompanion.insert(
              id: categoryData.id,
              name: categoryData.name,
              description: categoryData.description != null
                  ? Value(categoryData.description!)
                  : const Value.absent(),
              imageUrl: Value(categoryData.imageUrl),
            ),
          );
      return categoryData;
    } catch (e) {
      logging.e('Error creating category: $e');
      return null;
    }
  }

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final query = _localDatabase.select(
        _localDatabase.categoryDriftModel,
      )..orderBy([(t) => OrderingTerm(expression: t.name)]);
      final result = await query.get();
      return result
          .map(
            (e) => CategoryModel(
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

  Future<CategoryModel?> getCategoryById(String id) async {
    try {
      final query = _localDatabase.select(
        _localDatabase.categoryDriftModel,
      )..where((tbl) => tbl.id.equals(id));
      final result = await query.getSingleOrNull();
      if (result == null) return null;
      return CategoryModel(
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

  Future<List<CategoryModel>> getCategoriesByName(String name) async {
    try {
      final query =
          _localDatabase.select(
              _localDatabase.categoryDriftModel,
            )
            ..where((tbl) => tbl.name.like('%$name%'))
            ..orderBy([(t) => OrderingTerm(expression: t.name)]);
      final result = await query.get();
      return result
          .map(
            (e) => CategoryModel(
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
