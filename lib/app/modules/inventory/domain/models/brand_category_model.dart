import 'package:json_annotation/json_annotation.dart';


part 'brand_category_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class BrandCategoryModel {
  final String id;
  final String brandId;
  final String categoryId;

  BrandCategoryModel({
    required this.id,
    required this.brandId,
    required this.categoryId,
  });

  factory BrandCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$BrandCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandCategoryModelToJson(this);
}