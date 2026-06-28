// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandCategoryModel _$BrandCategoryModelFromJson(Map<String, dynamic> json) =>
    BrandCategoryModel(
      id: json['id'] as String,
      brandId: json['brand_id'] as String,
      categoryId: json['category_id'] as String,
    );

Map<String, dynamic> _$BrandCategoryModelToJson(BrandCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brand_id': instance.brandId,
      'category_id': instance.categoryId,
    };
