import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/app/modules/shop/infrastructure/providers/shop_providers.dart';
import 'package:mangueras_sv_entire/app/modules/shop/infrastructure/providers/cart_providers.dart';
import 'package:mangueras_sv_entire/core/core.dart';
import 'package:url_launcher/url_launcher.dart';

/// Página del carrito de compras
class ShopCartPage extends ConsumerWidget {
  const ShopCartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemsAsync = ref.watch(cartItemsProvider);
    final cartTotalAsync = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/shop/products'),

        ),
        title: const Text(
          'Mi Carrito',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        actions: [
          // Botón para limpiar carrito
          cartItemsAsync.when(
            data: (items) => items.isNotEmpty
                ? IconButton(
                    color: const Color.fromARGB(255, 212, 45, 45),
                    icon: const Icon(Icons.delete_sweep),
                    tooltip: 'Limpiar carrito',
                    onPressed: () => _showClearCartDialog(context, ref),
                    hoverColor: Colors.red.withOpacity(0.1),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: cartItemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return _EmptyCartView();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _CartItemCard(
                      item: item,
                      onUpdateQuantity: (newQuantity) {
                        ref
                            .read(cartActionsProvider.notifier)
                            .updateQuantity(item.productCode, newQuantity);
                      },
                      onRemove: () {
                        ref
                            .read(cartActionsProvider.notifier)
                            .removeItem(item.productCode);
                      },
                    );
                  },
                ),
              ),
              _CartSummary(
                cartTotalAsync: cartTotalAsync,
                onCheckout: () => _handleCheckout(context, ref, items),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  /// Muestra diálogo para confirmar limpieza del carrito
  void _showClearCartDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar Carrito'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar todos los productos del carrito?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              ref.read(cartActionsProvider.notifier).clearCart();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }

  /// Maneja el proceso de checkout (envío por WhatsApp)
  Future<void> _handleCheckout(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> items,
  ) async {
    // Construir mensaje para WhatsApp
    final buffer = StringBuffer();
    buffer.writeln('*PEDIDO - Mangueras SV*\n');
    buffer.writeln('*Detalle del pedido:*\n');

    double total = 0.0;
    for (var item in items) {
      final itemTotal = item.productPrice * item.quantity;
      total += itemTotal;

      buffer.writeln('━━━━━━━━━━━━━━━');
      buffer.writeln('*Producto:* ${item.productName}');
      buffer.writeln('*Código:* ${item.productCode}');
      if (item.brandName != null) {
        buffer.writeln('*Marca:* ${item.brandName}');
      }
      if (item.categoryName != null) {
        buffer.writeln('*Categoría:* ${item.categoryName}');
      }
      buffer.writeln(
        '*Precio unitario:* \$${item.productPrice.toStringAsFixed(2)}',
      );
      buffer.writeln('*Cantidad:* ${item.quantity}');
      buffer.writeln('*Subtotal:* \$${itemTotal.toStringAsFixed(2)}\n');
    }

    buffer.writeln('━━━━━━━━━━━━━━━');
    buffer.writeln('*TOTAL: \$${total.toStringAsFixed(2)}*');
    buffer.writeln('\n _Esperamos su confirmación_');


    // Codificar mensaje para URL
    final encodedMessage = Uri.encodeComponent(buffer.toString());
    final whatsappUrl = 'https://wa.me/$phoneNumber?text=$encodedMessage';

    try {
      final uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        // Opcional: Limpiar carrito después de enviar
        if (context.mounted) {
          final shouldClear = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Pedido Enviado'),
              content: const Text('¿Deseas limpiar el carrito?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Sí'),
                ),
              ],
            ),
          );

          if (shouldClear == true) {
            await ref.read(cartActionsProvider.notifier).clearCart();
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo abrir WhatsApp')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

/// Widget de vista vacía del carrito
class _EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'Tu carrito está vacío',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Agrega productos para continuar',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.go('/shop/products'),
            icon: const Icon(Icons.arrow_back_ios),
            label: const Text('Ir a Productos'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A237E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget de tarjeta de item del carrito
class _CartItemCard extends StatelessWidget {
  final dynamic item;
  final Function(int) onUpdateQuantity;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.onUpdateQuantity,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  item.productImageUrl != null &&
                      item.productImageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.productImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.inventory_2, size: 40),
                      ),
                    )
                  : const Icon(Icons.inventory_2, size: 40),
            ),
            const SizedBox(width: 12),
            // Información del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ref: ${item.productCode}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  if (item.brandName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Marca: ${item.brandName}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${item.productPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      const Spacer(),
                      // Controles de cantidad
                      _QuantityControls(
                        quantity: item.quantity,
                        onIncrement: () => onUpdateQuantity(item.quantity + 1),
                        onDecrement: () => onUpdateQuantity(item.quantity - 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal: \$${(item.productPrice * item.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: onRemove,
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text('Eliminar'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget de controles de cantidad
class _QuantityControls extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityControls({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: quantity > 1 ? onDecrement : null,
            icon: const Icon(Icons.remove, size: 18),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              quantity.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add, size: 18),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

/// Widget de resumen del carrito
class _CartSummary extends StatelessWidget {
  final AsyncValue<double> cartTotalAsync;
  final VoidCallback onCheckout;

  const _CartSummary({required this.cartTotalAsync, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                cartTotalAsync.when(
                  data: (total) => Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Text('Error'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onCheckout,
                icon: const Icon(FontAwesomeIcons.whatsapp, size: 24),
                label: const Text(
                  'Comprar por WhatsApp',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366), // WhatsApp green
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
