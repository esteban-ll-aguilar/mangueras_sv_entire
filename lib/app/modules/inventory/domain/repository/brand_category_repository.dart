import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/brand_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/category_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/brand_category_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/repository/brand_repository.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/repository/category_repository.dart';

abstract class BrandCategoryRepository
    implements BrandRepository, CategoryRepository {
  Future<List<BrandModel>> getAllBrandsByCategoryId(String categoryId);
  Future<List<CategoryModel>> getAllCategoriesByBrandId(String brandId);
  Future<List<Map<String, dynamic>>> getAllBrandsDropdownByCategoryId(
    String categoryId,
  );
  Future<List<Map<String, dynamic>>> getAllCategoriesDropdownByBrandId(
    String brandId,
  );
  Future<bool> associateBrandWithCategory(String brandId, String categoryId);
  Future<bool> removeAssociationBrandWithCategory(
    String brandId,
    String categoryId,
  );
  Future<String?> getAssociationIdFromCategoryIdAndBrandId(
    String categoryId,
    String brandId,
  );
  Future<List<BrandCategoryModel>> getBrandCategoriesByCategoryId(String categoryId);
  Future<List<Map<String, String>>> getBrandNameAndCategoryNameFromAssociationId(String associationId);
}
