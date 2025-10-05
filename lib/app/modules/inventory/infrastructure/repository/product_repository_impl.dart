import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/repository/product_repository.dart';
import 'package:mangueras_sv_entire/core/core.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepositoryImpl extends ProductRepository {
  final SupabaseClient _supabase;
  ProductRepositoryImpl(this._supabase);

  @override
  Future<ProductModel?> createProduct(ProductModel productData) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.productTable.value)
          .insert(productData.toJson())
          .select()
          .single();
      return ProductModel.fromJson(response);
    } catch (e) {
      logging.e('Error creating product: $e');
      return null;
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _supabase.from(supabaseTablesNames.productTable.value).select();
      final products = (response as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return products;
    } catch (e) {
      logging.e('Error fetching all products: $e');
      return [];
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.productTable.value)
          .select()
          .eq('code', id)
          .single();
      return ProductModel.fromJson(response);
    } catch (e) {
      logging.e('Error fetching product by ID: $e');
      return null;
    }
  }

  @override
  Future<List<ProductModel>> getProductsByName(String name) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.productTable.value)
          .select()
          .like('name', '%$name%');
      return (response as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      logging.e('Error fetching product by name: $e');
      return [];
    }
  }

  @override
  Future<ProductModel?> updateProduct(
    String productId,
    Map<String, dynamic> productData,
  ) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.productTable.value)
          .update(productData)
          .eq('code', productId)
          .select()
          .single();
      return ProductModel.fromJson(response);
    } catch (e) {
      logging.e('Error updating product: $e');
      return null;
    }
  }

  @override
  Future<List<ProductModel>> getAllProductsByBrandId(String brandId) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.productTable.value)
          .select('*, brand_category!inner(brand_id)')
          .eq('brand_category.brand_id', brandId);
          
      final products = (response as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return products;
    } catch (e) {
      logging.e('Error fetching all products by brand: $e');
      return [];
    }
  }

  @override
  Future<List<ProductModel>> getAllProductsByCategoryId(String categoryId) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.productTable.value)
          .select('*, brand_category!inner(category_id)')
          .eq('brand_category.category_id', categoryId);
          
      final products = (response as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return products;
    } catch (e) {
      logging.e('Error fetching all products by category: $e');
      return [];
    }
  }
  @override
  Future<List<Map<String, dynamic>>> getAllProductsWithDetails() async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.productTable.value)
          .select('*, brand_category!inner(*, brand(*), category(*))')
          .order('name', ascending: true);
          
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      logging.e('Error fetching all products with details: $e');
      return [];
    }
  }

}
