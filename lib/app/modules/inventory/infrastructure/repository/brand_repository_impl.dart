import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/brand_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/repository/brand_repository.dart';
import 'package:mangueras_sv_entire/core/core.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BrandRepositoryImpl extends BrandRepository {
  final SupabaseClient _supabase;
  BrandRepositoryImpl(this._supabase);

  @override
  Future<BrandModel?> createBrand(BrandModel brandData) async {
    try {
      final data = brandData.toJson()..remove('id');
      final response = await _supabase
          .from(supabaseTablesNames.brandTable.value)
          .insert(data)
          .select()
          .single();
      return BrandModel.fromJson(response);
    } catch (e) {
      logging.e('Error creating brand: $e');
      return null;
    }
  }

  @override
  Future<List<BrandModel>> getAllBrands() async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.brandTable.value)
          .select()
          .order('name', ascending: true);
      
      final brands = (response as List)
          .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return brands;
    } catch (e) {
      logging.e('Error fetching all brands: $e');
      return [];
    }
  }

  @override
  Future<BrandModel?> getBrandById(String id) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.brandTable.value)
          .select()
          .eq('id', id)
          .single();
      return BrandModel.fromJson(response);
    } catch (e) {
      logging.e('Error fetching brand by ID: $e');
      return null;
    }
  }

  @override
  Future<List<BrandModel>> getBrandsByName(String name) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.brandTable.value)
          .select()
          .like('name', '%$name%')
          .order('name', ascending: true);
      return (response as List)
          .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      logging.e('Error fetching brand by name: $e');
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllBrandsDropdown() async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.brandTable.value)
          .select('id, name, image_url')
          .order('name', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      logging.e('Error fetching brands dropdown: $e');
      return [];
    }
  }

  @override
  Future<BrandModel?> updateBrand(String brandId, Map<String, dynamic>  brandData) async {
    try {
      final response = await _supabase
          .from(supabaseTablesNames.brandTable.value)
          .update(brandData)
          .eq('id', brandId)
          .select()
          .single();
      return BrandModel.fromJson(response);
    } catch (e) {
      logging.e('Error updating brand: $e');
      return null;
    }
  }

}
