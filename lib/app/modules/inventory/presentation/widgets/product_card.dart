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
    final isInStock = (product.stockQuantity) > 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final cardHeight = constraints.maxHeight;
        
        // Categorías de tamaño más específicas
        final isVeryNarrow = cardWidth < 180;
        final isNarrow = cardWidth < 220;
        final isShort = cardHeight < 280;

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
              children: [
                // Imagen con altura adaptativa
                _buildImageSection(isActive, isInStock, isVeryNarrow, isShort),

                // Información del producto
                Expanded(
                  child: _buildInfoSection(
                    context,
                    isActive,
                    isVeryNarrow,
                    isNarrow,
                    isShort,
                    isInStock,
                  ),
                ),

                // Botones de acción solo en pantallas más grandes
                if (!isVeryNarrow && !isShort) 
                  _buildActionButtons(isActive),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection(bool isActive, bool isInStock, bool isVeryNarrow, bool isShort) {
    // Altura más agresivamente adaptativa
    double imageHeight;
    if (isVeryNarrow && isShort) {
      imageHeight = 80;
    } else if (isVeryNarrow || isShort) {
      imageHeight = 90;
    } else {
      imageHeight = 110;
    }

    return SizedBox(
      height: imageHeight,
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
                          _buildPlaceholder(isVeryNarrow),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _buildLoadingImage();
                      },
                    )
                  : _buildPlaceholder(isVeryNarrow),
            ),
          ),

          // Badges de estado más compactos
          Positioned(
            top: 4,
            right: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isActive) _buildStatusBadge('INACT', Colors.red, isVeryNarrow),
                if (!isActive && !isInStock) SizedBox(height: isVeryNarrow ? 1 : 2),
                if (!isInStock) _buildStatusBadge('SIN STOCK', Colors.orange, isVeryNarrow),
              ],
            ),
          ),

          // Código del producto más compacto
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isVeryNarrow ? 3 : 5,
                vertical: isVeryNarrow ? 1 : 2,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                product.code,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isVeryNarrow ? 8 : 9,
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
    bool isVeryNarrow,
    bool isNarrow,
    bool isShort,
    bool isInStock,
  ) {
    return Padding(
      padding: EdgeInsets.all(isVeryNarrow ? 6 : (isNarrow ? 8 : 12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del producto
          Flexible(
            child: Text(
              product.name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isVeryNarrow ? 11 : (isNarrow ? 12 : 14),
                color: isActive ? null : Colors.grey,
                height: 1.2,
              ),
              maxLines: isVeryNarrow ? 1 : (isShort ? 1 : 2),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Espaciado condicional
          if (!isVeryNarrow && !isShort) 
            SizedBox(height: isNarrow ? 2 : 4),

          // Marca y categoría solo en pantallas más grandes
          if (!isVeryNarrow && !isShort && (brandName != null || categoryName != null))
            Flexible(
              child: Text(
                _buildBrandCategoryText(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w500,
                  fontSize: isNarrow ? 10 : 11,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Descripción solo en pantallas grandes
          if (!isVeryNarrow && !isNarrow && !isShort && 
              product.description != null && product.description!.isNotEmpty)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  product.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                    fontSize: 10,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

          // Spacer flexible
          const Spacer(),

          // Precio y stock
          _buildPriceAndStock(context, isActive, isInStock, isVeryNarrow, isNarrow),
        ],
      ),
    );
  }

  String _buildBrandCategoryText() {
    if (brandName != null && categoryName != null) {
      return '$brandName • $categoryName';
    } else if (brandName != null) {
      return brandName!;
    } else if (categoryName != null) {
      return categoryName!;
    }
    return '';
  }

  Widget _buildPriceAndStock(
    BuildContext context,
    bool isActive,
    bool isInStock,
    bool isVeryNarrow,
    bool isNarrow,
  ) {
    if (isVeryNarrow) {
      // Layout ultra compacto para pantallas muy pequeñas
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: isActive ? Theme.of(context).primaryColor : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 2),
          _buildStockBadge(isInStock, true, isVeryNarrow),
        ],
      );
    } else if (isNarrow) {
      // Layout vertical compacto
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: isActive ? Theme.of(context).primaryColor : Colors.grey,
            ),
          ),
          const SizedBox(height: 3),
          _buildStockBadge(isInStock, true, false),
        ],
      );
    } else {
      // Layout horizontal para pantallas normales
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isActive ? Theme.of(context).primaryColor : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            flex: 1,
            child: _buildStockBadge(isInStock, false, false),
          ),
        ],
      );
    }
  }

  Widget _buildStockBadge(bool isInStock, bool compact, bool veryCompact) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: veryCompact ? 2 : (compact ? 3 : 5),
        vertical: veryCompact ? 1 : (compact ? 1 : 2),
      ),
      decoration: BoxDecoration(
        color: isInStock
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: isInStock ? Colors.green : Colors.red,
          width: 0.5,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          veryCompact ? '${product.stockQuantity}' : 'Stock: ${product.stockQuantity}',
          style: TextStyle(
            fontSize: veryCompact ? 8 : (compact ? 9 : 10),
            fontWeight: FontWeight.bold,
            color: isInStock ? Colors.green[700] : Colors.red[700],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.edit, size: 12),
              label: const Text('Editar', style: TextStyle(fontSize: 14)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 2),
                minimumSize: const Size(0, 24),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextButton.icon(
              onPressed: onToggleActive,
              icon: Icon(
                isActive ? Icons.visibility_off : Icons.visibility,
                size: 14,
              ),
              label: Text(
                isActive ? 'Ocultar' : 'Activar',
                style: const TextStyle(fontSize: 14),
              ),
              style: TextButton.styleFrom(
                foregroundColor: isActive ? Colors.orange : Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 1),
                minimumSize: const Size(0, 24),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color, bool isVeryNarrow) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isVeryNarrow ? 2 : 3,
        vertical: 1,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: isVeryNarrow ? 7 : 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isVeryNarrow) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined, 
            size: isVeryNarrow ? 20 : 28, 
            color: Colors.grey[400]
          ),
          if (!isVeryNarrow) ...[
            const SizedBox(height: 2),
            Text(
              'Sin imagen',
              style: TextStyle(fontSize: 9, color: Colors.grey[500]),
            ),
          ],
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
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}