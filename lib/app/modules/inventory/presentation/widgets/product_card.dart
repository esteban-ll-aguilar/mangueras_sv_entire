import 'package:flutter/material.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final String? brandName;
  final String? categoryName;
  final VoidCallback? onTap;
  final VoidCallback? onToggleActive;

  const ProductCard({
    super.key,
    required this.product,
    this.brandName,
    this.categoryName,
    this.onTap,
    this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = product.isActive == true;
    final isInStock = (product.stockQuantity ?? 0) > 0;
    final screenWidth = MediaQuery.of(context).size.width;

    //  Adaptar altura según el ancho de pantalla
    final isCompact = screenWidth < 600;

    return LayoutBuilder(
      builder: (context, constraints) {
        //  Calcular dimensiones basadas en las restricciones disponibles
        final cardWidth = constraints.maxWidth;
        final isNarrow = cardWidth < 200;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isActive
                  ? Colors.transparent
                  : Colors.red.withOpacity(0.3),
              width: isActive ? 0 : 1,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min, //  Usar tamaño mínimo
              children: [
                //  Imagen con altura fija pero responsive
                _buildImageSection(isActive, isInStock, isNarrow),

                //  Información del producto con flex adaptativo
                Expanded(
                  child: _buildInfoSection(
                    context,
                    isActive,
                    isNarrow,
                    isInStock,
                  ),
                ),

                //  Botones de acción compactos
                if (!isNarrow) _buildActionButtons(isActive),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection(bool isActive, bool isInStock, bool isNarrow) {
    return SizedBox(
      height: isNarrow ? 100 : 120, //  Altura fija adaptativa
      width: double.infinity,
      child: Stack(
        children: [
          // Imagen
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[100],
              child: (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                  ? Image.network(
                      product.imageUrl!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _buildLoadingImage();
                      },
                    )
                  : _buildPlaceholder(),
            ),
          ),

          // Badges de estado en posición absoluta
          Positioned(
            top: 6,
            right: 6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isActive) _buildStatusBadge('INACTIVO', Colors.red),
                if (!isActive && !isInStock) const SizedBox(height: 3),
                if (!isInStock) _buildStatusBadge('SIN STOCK', Colors.orange),
              ],
            ),
          ),

          // Código del producto
          Positioned(
            bottom: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                product.code,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isNarrow ? 9 : 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    bool isActive,
    bool isNarrow,
    bool isInStock,
  ) {
    return Padding(
      padding: EdgeInsets.all(isNarrow ? 8 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, //  Tamaño mínimo
        children: [
          // Nombre del producto
          Text(
            product.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isNarrow ? 12 : 14,
              color: isActive ? null : Colors.grey,
            ),
            maxLines: isNarrow ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          ),

          //  Espaciado condicional
          if (!isNarrow) const SizedBox(height: 4),

          // Marca y categoría (solo si hay espacio)
          if (!isNarrow && (brandName != null || categoryName != null))
            Text(
              '${brandName ?? ''} • ${categoryName ?? ''}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (product.description != null &&
              product.description!.isNotEmpty &&
              !isNarrow)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                product.description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[700],
                  fontSize: 11,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          //  Spacer flexible para empujar el precio hacia abajo
          const Spacer(),

          //  Precio y stock en diseño compacto
          _buildPriceAndStock(context, isActive, isInStock, isNarrow),
        ],
      ),
    );
  }

  Widget _buildPriceAndStock(
    BuildContext context,
    bool isActive,
    bool isInStock,
    bool isNarrow,
  ) {
    if (isNarrow) {
      //  Layout vertical compacto para pantallas pequeñas
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (product.price != null)
            Text(
              '\$${product.price!.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isActive ? Theme.of(context).primaryColor : Colors.grey,
              ),
            ),
          const SizedBox(height: 2),
          _buildStockBadge(isInStock, true),
        ],
      );
    } else {
      //  Layout horizontal para pantallas normales
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Precio
          if (product.price != null)
            Flexible(
              child: Text(
                '\$${product.price!.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Stock
          _buildStockBadge(isInStock, false),
        ],
      );
    }
  }

  Widget _buildStockBadge(bool isInStock, bool compact) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 4 : 6,
        vertical: compact ? 1 : 2,
      ),
      decoration: BoxDecoration(
        color: isInStock
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isInStock ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Text(
        'Stock: ${product.stockQuantity ?? 0}',
        style: TextStyle(
          fontSize: compact ? 9 : 10,
          fontWeight: FontWeight.bold,
          color: isInStock ? Colors.green[700] : Colors.red[700],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.edit, size: 14),
              label: const Text('Editar', style: TextStyle(fontSize: 11)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 2),
                minimumSize: const Size(0, 28),
              ),
            ),
          ),
          const SizedBox(width: 4),
          TextButton.icon(
            onPressed: onToggleActive,
            icon: Icon(
              isActive ? Icons.visibility_off : Icons.visibility,
              size: 14,
            ),
            label: Text(
              isActive ? 'Ocultar producto' : 'Activar producto',
              style: const TextStyle(fontSize: 11),
            ),
            style: TextButton.styleFrom(
              foregroundColor: isActive ? Colors.orange : Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 2),
              minimumSize: const Size(0, 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 32, color: Colors.grey[400]),
          const SizedBox(height: 4),
          Text(
            'Sin imagen',
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[200],
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
