import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/repository/product_repository.dart';
import 'package:mangueras_sv_entire/core/core.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mangueras_sv_entire/core/utils/search_utils.dart';

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
  /// Obtiene todos los productos desde la vista 'products_view_flat'
  /// Estructura del JSON devuelto por la vista:
  ///
  /// {
  ///    "code":,
  ///    "name":"",
  ///    "description":"",
  ///    "image_url":"",
  ///    "price": 0,
  ///    "stock_quantity": 0,
  ///    "is_active":true,
  ///    "brand_category_id": "",
  ///    "brand_id": "",
  ///    "brand_name":"",
  ///    "category_id": "",
  ///    "category_name":""
  /// }
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _supabase.from('products_view_flat').select();
      // logging.d('Response from products_view_flat: ${response[0]}');
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
          .from('products_view_flat')
          .select()
          .eq('code', id)
          .single();
      return ProductModel.fromJson(response);
    } catch (e) {
      logging.e('Error fetching product by ID: $e');
      return null;
    }
  }

  /// Fase 3: escapa comodines de LIKE para no exponer/alterar la consulta.
  String _escapeLike(String input) =>
      input.replaceAll('\\', '\\\\').replaceAll('%', '\\%').replaceAll('_', '\\_');

  @override
  Future<List<ProductModel>> getProductsByName(String name) async {
    try {
<<<<<<< HEAD
      final safe = _escapeLike(name.trim());
      if (safe.isEmpty) return [];
      final response = await _supabase
          .from('products_view_flat')
          .select()
          .like('name', '%$safe%');
=======
      final escapedName = escapeLikePattern(name.trim());
      final response = await _supabase
          .from('products_view_flat')
          .select()
          .like('name', '%$escapedName%');
>>>>>>> 66286d4 (feat: enhance error handling and UI feedback across inventory and shop modules)
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
          .from('products_view_flat')
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
          .from('products_view_flat')
          .select()
          .eq('brand_id', brandId);

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
  Future<List<ProductModel>> getAllFilteredProducts({
    String? productName,
    bool? isActive,
    Set<String>? brandIds,
    Set<String>? categoryIds,
  }) async {
    try {
<<<<<<< HEAD
      var query = _supabase
          .from('products_view_flat')
          .select();
          if (productName != null && productName.trim().isNotEmpty) {
            final safe = _escapeLike(productName.trim());
            query = query.or('name.ilike.%$safe%,code.ilike.%$safe%');
          }
          if (brandIds != null && brandIds.isNotEmpty) {
            query = query.inFilter('brand_id', brandIds.toList());
          }
          if (categoryIds != null && categoryIds.isNotEmpty) {
            query = query.inFilter('category_id', categoryIds.toList());
          }
          if (isActive != null) {
            query = query.eq('is_active', isActive);
          }
=======
      var query = _supabase.from('products_view_flat').select();
      if (productName != null && productName.isNotEmpty) {
        query = query.or('name.ilike.%$productName%,code.ilike.%$productName%');
      }
      if (brandIds != null && brandIds.isNotEmpty) {
        query = query.inFilter('brand_id', brandIds.toList());
      }
      if (categoryIds != null && categoryIds.isNotEmpty) {
        query = query.inFilter('category_id', categoryIds.toList());
      }
      if (isActive != null) {
        query = query.eq('is_active', isActive);
      }
>>>>>>> 66286d4 (feat: enhance error handling and UI feedback across inventory and shop modules)

      query.order('name', ascending: true);
      final response = await query;

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
  Future<List<ProductModel>> getAllProductsByCategoryId(
    String categoryId,
  ) async {
    try {
      final response = await _supabase
          .from('products_view_flat')
          .select()
          .eq('category_id', categoryId);

      final products = (response as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return products;
    } catch (e) {
      logging.e('Error fetching all products by category: $e');
      return [];
    }
  }
}
