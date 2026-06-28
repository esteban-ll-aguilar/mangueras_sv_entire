import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/category_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/repository/category_repository.dart';
import 'package:mangueras_sv_entire/core/core.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  final SupabaseClient _supabase;
  CategoryRepositoryImpl(this._supabase);

  @override
  Future<CategoryModel?> createCategory(CategoryModel categoryData) async {
    try {
      final data = categoryData.toJson()..remove('id');
      final response = await _supabase
          .from(supabaseTablesNames.categoryTable.value)
          .insert(data)
          .select()
          .single();
      return CategoryModel.fromJson(response);
    } catch (e) {
      logging.e('Error creating category: $e');
      return null;
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.categoryTable.value)
          .select()
          .order('name', ascending: true);
      final categories = (response as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return categories;
    } catch (e) {
      logging.e('Error fetching all categories: $e');
      return [];
    }
  }

  @override
  Future<CategoryModel?> getCategoryById(String id) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.categoryTable.value)
          .select()
          .eq('id', id)
          .single();
      return CategoryModel.fromJson(response);
    } catch (e) {
      logging.e('Error fetching category by ID: $e');
      return null;
    }
  }

  @override
  Future<List<CategoryModel>> getCategoriesByName(String name) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.categoryTable.value)
          .select()
          .like('name', '%$name%')
          .order('name', ascending: true);
      return (response as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      logging.e('Error fetching category by name: $e');
      return [];
    }
  }


  @override
  Future<List<CategoryModel>> getMainCategories() async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.categoryTable.value)
          .select()
          .eq('is_main_category', true)
          .order('name', ascending: true);
      return (response as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      logging.e('Error fetching main categories: $e');
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCategoriesDropdown() async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.categoryTable.value)
          .select('id, name')
          .order('name', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      logging.e('Error fetching categories for dropdown: $e');
      return [];
    }
  }

  @override
  Future<CategoryModel?> updateCategory(String categoryId, Map<String, dynamic> categoryData) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.categoryTable.value)
          .update(categoryData)
          .eq('id', categoryId)
          .select()
          .single();
      
      return CategoryModel.fromJson(response);
    } catch (e) {
      logging.e('Error updating category: $e');
      return null;
    }
  }
}
