// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  code: json['code'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  imageUrl: json['image_url'] as String? ?? '',
  brandCategoryId: json['brand_category_id'] as String,
  price: (json['price'] as num).toDouble(),
  stockQuantity: (json['stock_quantity'] as num).toInt(),
  isActive: json['is_active'] as bool,
  brandId: json['brand_id'] as String?,
  brandName: json['brand_name'] as String?,
  categoryId: json['category_id'] as String?,
  categoryName: json['category_name'] as String?,
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'brand_category_id': instance.brandCategoryId,
      'price': instance.price,
      'stock_quantity': instance.stockQuantity,
      'is_active': instance.isActive,
    };
