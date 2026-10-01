import 'order_item_model.dart';

/// Pedido simple: carrito guardado + compra + historial.
/// status: pendiente | vendido | cancelado
class OrderModel {
  final String id;
  final String userId;
  final String status;
  final double total;
  final DateTime? createdAt;
  final DateTime? soldAt;
  final String? soldBy;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.total,
    this.createdAt,
    this.soldAt,
    this.soldBy,
    this.items = const [],
  });

  bool get isPending => status == 'pendiente';
  bool get isSold => status == 'vendido';

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['order_items'] as List?;
    return OrderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      status: (json['status'] as String?) ?? 'pendiente',
      total: ((json['total'] as num?) ?? 0).toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'].toString()),
      soldAt: json['sold_at'] == null
          ? null
          : DateTime.tryParse(json['sold_at'].toString()),
      soldBy: json['sold_by'] as String?,
      items: rawItems == null
          ? const []
          : rawItems
              .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'status': status,
        'total': total,
      };
}
