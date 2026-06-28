import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/category_model.dart';


abstract class CategoryRepository {
  Future<CategoryModel?> createCategory(CategoryModel categoryData);
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel?> getCategoryById(String id);
  Future<List<CategoryModel>> getCategoriesByName(String name);
  Future<List<CategoryModel>> getMainCategories();
  Future<CategoryModel?> updateCategory(String categoryId, Map<String, dynamic>  categoryData);
  Future<List<Map<String, dynamic>>> getCategoriesDropdown();
}