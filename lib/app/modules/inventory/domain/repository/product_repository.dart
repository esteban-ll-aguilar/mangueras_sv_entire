import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';

abstract class ProductRepository {
  Future<ProductModel?> createProduct(ProductModel productData);
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel?> getProductById(String id);
  Future<List<ProductModel>> getProductsByName(String name);
  Future<ProductModel?> updateProduct(
    String productId,
    Map<String, dynamic> productData,
  );
  Future<List<ProductModel>> getAllProductsByBrandId(String brandId);
  Future<List<ProductModel>> getAllProductsByCategoryId(String categoryId);
  Future<List<ProductModel>> getAllFilteredProducts({
    String? productName,
    bool? isActive,
    Set<String>? brandIds,
    Set<String>? categoryIds,
  });
}
