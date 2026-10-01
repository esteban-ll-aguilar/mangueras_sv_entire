import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/orders/domain/models/profile_model.dart';
import 'package:mangueras_sv_entire/app/modules/orders/domain/models/order_model.dart';
import 'package:mangueras_sv_entire/app/modules/orders/infrastructure/repository/order_repository_impl.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';

final orderRepositoryProvider = Provider<OrderRepositoryImpl>((ref) {
  return OrderRepositoryImpl(ref.watch(supabaseProvider));
});

final myProfileProvider = FutureProvider<ProfileModel?>((ref) async {
  return ref.watch(orderRepositoryProvider).getMyProfile();
});

final isAdminProvider = FutureProvider<bool>((ref) async {
  final p = await ref.watch(myProfileProvider.future);
  return p?.isAdmin ?? false;
});

final myOrdersProvider = FutureProvider<List<OrderModel>>((ref) async {
  return ref.watch(orderRepositoryProvider).getMyOrders();
});

final pendingOrdersProvider =
    FutureProvider<List<OrderModel>>((ref) async {
  return ref.watch(orderRepositoryProvider).getPendingOrders();
});
