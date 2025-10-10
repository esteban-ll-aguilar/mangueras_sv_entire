import 'package:json_annotation/json_annotation.dart';

part 'cart_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CartItemModel {
  final String productCode;
  final String productName;
  final String? productImageUrl;
  final double productPrice;
  final int quantity;
  final String? brandName;
  final String? categoryName;
  final DateTime addedAt;

  CartItemModel({
    required this.productCode,
    required this.productName,
    this.productImageUrl,
    required this.productPrice,
    required this.quantity,
    this.brandName,
    this.categoryName,
    required this.addedAt,
  });

  double get total => productPrice * quantity;


  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

}