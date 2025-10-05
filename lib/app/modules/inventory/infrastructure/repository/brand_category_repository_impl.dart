import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/brand_category_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/brand_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/category_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/repository/brand_category_repository.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/repository/brand_repository_impl.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/repository/category_repository_impl.dart';
import 'package:mangueras_sv_entire/core/core.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BrandCategoryRepositoryImpl extends BrandCategoryRepository {
  final BrandRepositoryImpl _brandRepo;
  final CategoryRepositoryImpl _categoryRepo;
  final SupabaseClient _supabase;

  BrandCategoryRepositoryImpl(this._supabase)
    : _brandRepo = BrandRepositoryImpl(_supabase),
      _categoryRepo = CategoryRepositoryImpl(_supabase);

  // Métodos de BrandRepository
  @override
  Future<BrandModel?> createBrand(BrandModel brandData) =>
      _brandRepo.createBrand(brandData);

  @override
  Future<List<BrandModel>> getAllBrands() => _brandRepo.getAllBrands();

  @override
  Future<BrandModel?> getBrandById(String id) => _brandRepo.getBrandById(id);

  @override
  Future<List<BrandModel>> getBrandsByName(String name) =>
      _brandRepo.getBrandsByName(name);

  @override
  Future<BrandModel?> updateBrand(
    String brandId,
    Map<String, dynamic> brandData,
  ) => _brandRepo.updateBrand(brandId, brandData);

  @override
  Future<List<Map<String, dynamic>>> getAllBrandsDropdown() =>
      _brandRepo.getAllBrandsDropdown();

  // Métodos de CategoryRepository
  @override
  Future<CategoryModel?> createCategory(CategoryModel categoryData) =>
      _categoryRepo.createCategory(categoryData);

  @override
  Future<List<CategoryModel>> getAllCategories() =>
      _categoryRepo.getAllCategories();

  @override
  Future<CategoryModel?> getCategoryById(String id) =>
      _categoryRepo.getCategoryById(id);

  @override
  Future<List<CategoryModel>> getCategoriesByName(String name) =>
      _categoryRepo.getCategoriesByName(name);

  @override
  Future<CategoryModel?> updateCategory(
    String categoryId,
    Map<String, dynamic> categoryData,
  ) => _categoryRepo.updateCategory(categoryId, categoryData);

  @override
  Future<List<Map<String, dynamic>>> getCategoriesDropdown() =>
      _categoryRepo.getCategoriesDropdown();

  @override
  Future<List<BrandModel>> getAllBrandsByCategoryId(String categoryId) async {
    try {
      // obtain all branchs ids associated with the category
      final response = await _supabase
          .from(supabaseTablesNames.brandCategoryTable.value)
          .select('brand(*)')
          .eq('category_id', categoryId)
          .order(
            'name',
            referencedTable: supabaseTablesNames.brandTable.value,
            ascending: true,
          );
      final brands = (response as List)
          .map((e) => BrandModel.fromJson(e['brand'] as Map<String, dynamic>))
          .toList();
      return brands;
    } catch (e) {
      logging.e('Error fetching all brands by category: $e');
      return [];
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategoriesByBrandId(String brandId) async {
    try {
      // obtain all category ids associated with the brand
      final response = await _supabase
          .from(supabaseTablesNames.brandCategoryTable.value)
          .select('category(*)')
          .eq('brand_id', brandId)
          .order(
            'name',
            ascending: true,
            referencedTable: supabaseTablesNames.categoryTable.value,
          );

      final categories = (response as List)
          .map(
            (e) =>
                CategoryModel.fromJson(e['category'] as Map<String, dynamic>),
          )
          .toList();
      return categories;
    } catch (e) {
      logging.e('Error fetching all categories by brand: $e');
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllCategoriesDropdownByBrandId(
    String brandId,
  ) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.brandCategoryTable.value)
          .select('category(id, name, image_url)')
          .eq('brand_id', brandId)
          .order(
            'name',
            referencedTable: supabaseTablesNames.categoryTable.value,
            ascending: true,
          );
      // Fetch all categories associated with the obtained category IDs
      final categories = (response as List)
          .map((e) => e['category'] as Map<String, dynamic>)
          .toList();
      return categories;
    } catch (e) {
      logging.e('Error fetching all categories by brand: $e');
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllBrandsDropdownByCategoryId(
    String categoryId,
  ) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.brandCategoryTable.value)
          .select('brand(id, name, image_url)')
          .eq('category_id', categoryId)
          .order(
            'name',
            referencedTable: supabaseTablesNames.brandTable.value,
            ascending: true,
          );
      // Fetch all categories associated with the obtained category IDs
      final brands = (response as List)
          .map((e) => e['brand'] as Map<String, dynamic>)
          .toList();
      return brands;
    } catch (e) {
      logging.e('Error fetching dropdown all brands by category: $e');
      return [];
    }
  }

  @override
  Future<bool> associateBrandWithCategory(
    String brandId,
    String categoryId,
  ) async {
    try {
      await _supabase.from(supabaseTablesNames.brandCategoryTable.value).insert(
        {'brand_id': brandId, 'category_id': categoryId},
      );
      return true;
    } catch (e) {
      logging.e('Error linking brand to category: $e');
      return false;
    }
  }

  @override
  Future<bool> removeAssociationBrandWithCategory(
    String brandId,
    String categoryId,
  ) async {
    try {
      await _supabase
          .from(supabaseTablesNames.brandCategoryTable.value)
          .delete()
          .eq('brand_id', brandId)
          .eq('category_id', categoryId);
      return true;
    } catch (e) {
      logging.e('Error unlinking brand from category: $e');
      return false;
    }
  }
  @override
  Future<String?> getAssociationIdFromCategoryIdAndBrandId(
    String categoryId,
    String brandId,
  ) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.brandCategoryTable.value)
          .select('id')
          .eq('category_id', categoryId)
          .eq('brand_id', brandId)
          .single();
      final associationId = response['id'] as String;
      if (associationId.isEmpty) {
        logging.e('No association found for category $categoryId and brand $brandId');
        return null;
      }
      return associationId;
    } catch (e) {
      logging.e('Error fetching associations by category and brand: $e');
      return null;
    }
  }

  @override
  Future<List<BrandCategoryModel>> getBrandCategoriesByCategoryId(String categoryId) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.brandCategoryTable.value)
          .select()
          .eq('category_id', categoryId);

      return (response as List)
          .map((json) => BrandCategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener asociaciones marca-categoría por categoría: $e');
    }
  }

  @override
  // Returns a list of maps with brand and category names
  // Each map corresponds to one association identified by the associationId
  // If no association is found, returns an empty list
  //
  // Example: {
  //   'brand_id': 'BrandID',
  //   'brand_name': 'BrandName',
  //   'category_id': 'CategoryID',
  //   'category_name': 'CategoryName'
  // }
  Future<List<Map<String, String>>> getBrandNameAndCategoryNameFromAssociationId(String associationId) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.brandCategoryTable.value)
          .select('brand(id, name), category(id, name)')
          .eq('id', associationId)
          .single();

      logging.i('Response for associationId $associationId: $response');

      return [{
        'brand_id': response['brand']['id'] as String,
        'brand_name': response['brand']['name'] as String,
        'category_id': response['category']['id'] as String,
        'category_name': response['category']['name'] as String,
      }];
    } catch (e) {
      throw Exception('Error al obtener asociaciones marca-categoría por categoría: $e');
    }
  }


}
