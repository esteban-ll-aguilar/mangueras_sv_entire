// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      productCode: json['product_code'] as String,
      productName: json['product_name'] as String,
      productImageUrl: json['product_image_url'] as String?,
      productPrice: (json['product_price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      brandName: json['brand_name'] as String?,
      categoryName: json['category_name'] as String?,
      addedAt: DateTime.parse(json['added_at'] as String),
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'product_code': instance.productCode,
      'product_name': instance.productName,
      'product_image_url': instance.productImageUrl,
      'product_price': instance.productPrice,
      'quantity': instance.quantity,
      'brand_name': instance.brandName,
      'category_name': instance.categoryName,
      'added_at': instance.addedAt.toIso8601String(),
    };
