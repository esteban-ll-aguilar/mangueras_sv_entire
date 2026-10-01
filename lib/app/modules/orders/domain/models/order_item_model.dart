class OrderItemModel {
  final String? id;
  final String? orderId;
  final String productCode;
  final int quantity;
  final double unitPrice;
  final double? subtotal;

  const OrderItemModel({
    this.id,
    this.orderId,
    required this.productCode,
    required this.quantity,
    required this.unitPrice,
    this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      OrderItemModel(
        id: json['id'] as String?,
        orderId: json['order_id'] as String?,
        productCode: json['product_code'] as String,
        quantity: (json['quantity'] as num).toInt(),
        unitPrice: ((json['unit_price'] as num?) ?? 0).toDouble(),
        subtotal: json['subtotal'] == null
            ? null
            : ((json['subtotal'] as num).toDouble()),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (orderId != null) 'order_id': orderId,
        'product_code': productCode,
        'quantity': quantity,
        'unit_price': unitPrice,
      };
}
