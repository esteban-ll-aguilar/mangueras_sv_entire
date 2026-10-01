import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/widgets/auth_reusable_widgets.dart';
import 'package:mangueras_sv_entire/app/modules/orders/domain/models/order_model.dart';
import 'package:mangueras_sv_entire/app/modules/orders/infrastructure/providers/order_providers.dart';
import 'package:mangueras_sv_entire/core/routes/app_router.dart';

/// Admin: pedidos pendientes + botón Vendido (descuenta stock vía RPC sell_order).
class AdminOrdersPage extends ConsumerStatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  ConsumerState<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends ConsumerState<AdminOrdersPage> {
  final Set<String> _processing = {};

  Future<void> _markSold(OrderModel order) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Marcar como vendido'),
        content: Text(
            'Se descontará stock de ${order.items.length} items (total \$${order.total.toStringAsFixed(2)}). ¿Continuar?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Vender')),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _processing.add(order.id));
    try {
      await ref.read(orderRepositoryProvider).markAsSold(order.id);
      ref.invalidate(pendingOrdersProvider);
      ref.invalidate(myOrdersProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pedido vendido, stock descontado')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _processing.remove(order.id));
    }
  }

  Future<void> _cancel(OrderModel order) async {
    try {
      await ref.read(orderRepositoryProvider).cancelOrder(order.id);
      ref.invalidate(pendingOrdersProvider);
      ref.invalidate(myOrdersProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdminAsync = ref.watch(isAdminProvider);
    final pendingAsync = ref.watch(pendingOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        leading: AuthReusableWidgets.backButton(
          context,
          routeName: AppRouteNames.home.name,
        ),
        title: const Text('Pedidos pendientes'),
      ),
      body: isAdminAsync.when(
        data: (isAdmin) {
          if (!isAdmin) {
            return const Center(
                child: Text('Solo administradores pueden ver esta página'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(pendingOrdersProvider),
            child: pendingAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return ListView(children: const [
                    SizedBox(height: 80),
                    Icon(Icons.check_circle_outline,
                        size: 80, color: Colors.green),
                    SizedBox(height: 16),
                    Center(child: Text('Sin pedidos pendientes')),
                  ]);
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (_, i) {
                    final o = orders[i];
                    final busy = _processing.contains(o.id);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        title: Text(
                            'Pedido ${o.id.substring(0, 8)} • \$${o.total.toStringAsFixed(2)}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${o.items.length} items'),
                        children: [
                          ...o.items.map((it) => ListTile(
                                dense: true,
                                title: Text(it.productCode),
                                subtitle: Text(
                                    'x${it.quantity} • \$${it.unitPrice.toStringAsFixed(2)}'),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: busy ? null : () => _markSold(o),
                                    icon: busy
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2))
                                        : const Icon(Icons.sell_outlined),
                                    label: Text(busy
                                        ? 'Vendiendo...'
                                        : 'Vendido (descontar stock)'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: busy ? null : () => _cancel(o),
                                  child: const Text('Cancelar',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
