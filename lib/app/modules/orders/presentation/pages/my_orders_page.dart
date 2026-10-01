import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/widgets/auth_reusable_widgets.dart';
import 'package:mangueras_sv_entire/app/modules/orders/domain/models/order_model.dart';
import 'package:mangueras_sv_entire/app/modules/orders/infrastructure/providers/order_providers.dart';
import 'package:mangueras_sv_entire/core/routes/app_router.dart';

/// Mis Pedidos (cliente): carrito guardado + compras + historial.
class MyOrdersPage extends ConsumerWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(myOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        leading: AuthReusableWidgets.backButton(
          context,
          routeName: AppRouteNames.home.name,
        ),
        title: const Text('Mis Pedidos'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(myOrdersProvider),
        child: ordersAsync.when(
          data: (orders) {
            if (orders.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 80),
                  Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Center(child: Text('Aún no tienes pedidos')),
                ],
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (_, i) => _OrderCard(order: orders[i]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/shop/products'),
        icon: const Icon(Icons.shopping_bag_outlined),
        label: const Text('Seguir comprando'),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final shortId =
        order.id.length > 8 ? order.id.substring(0, 8) : order.id;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text('Pedido $shortId',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            '${order.items.length} items • \$${order.total.toStringAsFixed(2)}'),
        trailing: _StatusChip(status: order.status),
        children: [
          ...order.items.map((it) => ListTile(
                dense: true,
                title: Text(it.productCode),
                subtitle: Text('x${it.quantity} • \$${it.unitPrice.toStringAsFixed(2)}'),
                trailing: Text(
                    '\$${((it.subtotal) ?? it.unitPrice * it.quantity).toStringAsFixed(2)}'),
              )),
          if (order.createdAt != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('Creado: ${order.createdAt}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final c = status == 'vendido'
        ? Colors.green
        : status == 'cancelado'
            ? Colors.red
            : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: c.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20)),
      child: Text(status,
          style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
