import 'package:mangueras_sv_entire/app/modules/orders/domain/models/order_item_model.dart';
import 'package:mangueras_sv_entire/app/modules/orders/domain/models/order_model.dart';
import 'package:mangueras_sv_entire/app/modules/orders/domain/models/profile_model.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepositoryImpl {
  final SupabaseClient _supabase;
  OrderRepositoryImpl(this._supabase);

  Future<ProfileModel?> getMyProfile() async {
    try {
      final uid = _supabase.auth.currentUser?.id;
      if (uid == null) return null;
      final row =
          await _supabase.from('profiles').select().eq('id', uid).single();
      return ProfileModel.fromJson(row);
    } catch (e) {
      logging.e('getMyProfile: $e');
      return null;
    }
  }

  /// Guarda lo del carrito como pedido pendiente (carrito + compra en nube).
  Future<OrderModel?> createOrderFromCart(
      List<OrderItemModel> cartItems) async {
    try {
      final uid = _supabase.auth.currentUser?.id;
      if (uid == null) throw Exception('Debes iniciar sesión');
      if (cartItems.isEmpty) throw Exception('Carrito vacío');

      final total = cartItems.fold<double>(
          0, (s, i) => s + i.unitPrice * i.quantity);

      final orderRow = await _supabase
          .from('orders')
          .insert({'user_id': uid, 'status': 'pendiente', 'total': total})
          .select()
          .single();

      final orderId = orderRow['id'] as String;
      final itemsPayload =
          cartItems.map((i) => {'order_id': orderId, ...i.toJson()}).toList();
      await _supabase.from('order_items').insert(itemsPayload);

      final full = await _supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('id', orderId)
          .single();
      return OrderModel.fromJson(full);
    } catch (e) {
      logging.e('createOrderFromCart: $e');
      rethrow;
    }
  }

  Future<List<OrderModel>> getMyOrders() async {
    try {
      final uid = _supabase.auth.currentUser?.id;
      if (uid == null) return [];
      final rows = await _supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('user_id', uid)
          .order('created_at', ascending: false);
      return (rows as List)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      logging.e('getMyOrders: $e');
      return [];
    }
  }

  /// Admin: ver todos los pendientes
  Future<List<OrderModel>> getPendingOrders() async {
    try {
      final rows = await _supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('status', 'pendiente')
          .order('created_at', ascending: false);
      return (rows as List)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      logging.e('getPendingOrders: $e');
      return [];
    }
  }

  /// Admin: marca vendido y descuenta stock (RPC sell_order, transaccional).
  Future<void> markAsSold(String orderId) async {
    try {
      await _supabase.rpc('sell_order', params: {'p_order_id': orderId});
    } catch (e) {
      logging.e('markAsSold: $e');
      rethrow;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await _supabase
          .from('orders')
          .update({'status': 'cancelado'}).eq('id', orderId);
    } catch (e) {
      logging.e('cancelOrder: $e');
      rethrow;
    }
  }
}
