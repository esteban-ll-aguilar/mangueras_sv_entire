import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/brand_model.dart';


abstract class BrandRepository {
  Future<BrandModel?> createBrand(BrandModel brandData);
  Future<List<BrandModel>> getAllBrands();
  Future<BrandModel?> getBrandById(String id);
  Future<List<BrandModel>> getBrandsByName(String name);
  Future<BrandModel?> updateBrand(String brandId, Map<String, dynamic> brandData);
  Future<List<Map<String, dynamic>>> getAllBrandsDropdown();
}