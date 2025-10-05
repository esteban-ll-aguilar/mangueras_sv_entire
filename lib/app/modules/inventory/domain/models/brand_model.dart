import 'package:json_annotation/json_annotation.dart';
part 'brand_model.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class BrandModel {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;

  BrandModel({
    required this.id,
    required this.name,
    this.description = '',
    this.imageUrl = '',
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);
  Map<String, dynamic> toJson() => _$BrandModelToJson(this);
}