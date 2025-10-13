import 'package:json_annotation/json_annotation.dart';
part 'product_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ProductModel {
  final String code;
  final String name;
  final String? description;
  final String? imageUrl;
  final String brandCategoryId;
  final double price;
  final int stockQuantity;
  final bool isActive;

  /// Campos adicionales para facilitar el acceso a marca y categoría
  @JsonKey(includeFromJson: true, includeToJson: false)
  final String? brandId; // ID de la marca (opcional)
  @JsonKey(includeFromJson: true, includeToJson: false)
  final String? brandName; // Nombre de la marca (opcional)
  @JsonKey(includeFromJson: true, includeToJson: false)
  final String? categoryId; // ID de la categoría (opcional)
  @JsonKey(includeFromJson: true, includeToJson: false)
  final String? categoryName; // Nombre de la categoría (opcional)

  ProductModel({
    required this.code,
    required this.name,
    this.description = '',
    this.imageUrl = '',
    required this.brandCategoryId,
    required this.price,
    required this.stockQuantity,
    required this.isActive,
    this.brandId,
    this.brandName,
    this.categoryId,
    this.categoryName,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}