import 'package:flutter/material.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';

/// Widget que muestra una tarjeta de producto con su información
class ShopProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final Function(int quantity)? onAddToCart;

  const ShopProductCard({
    Key? key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  }) : super(key: key);

  @override
  State<ShopProductCard> createState() => _ShopProductCardState();
}

class _ShopProductCardState extends State<ShopProductCard> {
  int _quantity = 1;

  void _incrementQuantity() {
    if (_quantity < widget.product.stockQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  void _showDescriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Información del Producto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Código: ${widget.product.code}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              if (widget.product.brandName != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Marca: ${widget.product.brandName}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
              if (widget.product.categoryName != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Categoría: ${widget.product.categoryName}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    'Descripción: \n' +
                    (widget.product.description ?? 'Sin descripción disponible.'),
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsivo basado en el ancho disponible
        final isCompact = constraints.maxWidth < 300;
        
        return Card(
          elevation: 3,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: _showDescriptionDialog,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildProductImage(isCompact),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(isCompact ? 8 : 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildProductHeader(isCompact),
                        SizedBox(height: isCompact ? 2 : 4),
                        _buildBrandAndCategory(isCompact),
                        const Spacer(),
                        _buildPriceAndStock(isCompact),
                        SizedBox(height: isCompact ? 4 : 6),
                        _buildAddToCartSection(isCompact),
                        SizedBox(height: isCompact ? 4 : 6),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Imagen del producto optimizada
  Widget _buildProductImage(bool isCompact) {
    final imageHeight = isCompact ? 100.0 : 120.0;
    
    return Container(
      height: imageHeight,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Imagen
          SizedBox.expand(
            child: widget.product.imageUrl != null && widget.product.imageUrl!.isNotEmpty
                ? Image.network(
                    widget.product.imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: SizedBox(
                          width: isCompact ? 20 : 24,
                          height: isCompact ? 20 : 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(
                        Icons.inventory_2, 
                        size: isCompact ? 35 : 40, 
                        color: Colors.grey[400]
                      ),
                    ),
                  )
                : Center(
                    child: Icon(
                      Icons.inventory_2, 
                      size: isCompact ? 35 : 40, 
                      color: Colors.grey[400]
                    ),
                  ),
          ),
          // Badge de stock
          if (widget.product.stockQuantity <= 5 && widget.product.stockQuantity > 0)
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 3 : 4, 
                  vertical: 2
                ),
                decoration: BoxDecoration(
                  color: Colors.orange[600],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isCompact ? 'Pocas' : 'Pocas unidades',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isCompact ? 7 : 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          // Badge sin stock
          if (widget.product.stockQuantity == 0)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 6 : 8, 
                      vertical: isCompact ? 3 : 4
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'SIN STOCK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isCompact ? 9 : 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Header con nombre y código del producto
  Widget _buildProductHeader(bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.product.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isCompact ? 12 : 14,
            color: const Color(0xFF1A237E),
          ),
          maxLines: isCompact ? 1 : 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: isCompact ? 1 : 2),
        Text(
          'Ref: ${widget.product.code}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: isCompact ? 9 : 11,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Marca y categoría del producto
  Widget _buildBrandAndCategory(bool isCompact) {
    final brand = widget.product.brandName;
    final category = widget.product.categoryName;

    if (brand == null && category == null) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (brand != null) ...[
          Row(
            children: [
              Icon(
                Icons.business,
                size: isCompact ? 9 : 11,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  brand,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: isCompact ? 9 : 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (category != null) SizedBox(height: isCompact ? 0 : 1),
        ],
        if (category != null)
          Row(
            children: [
              Icon(
                Icons.category,
                size: isCompact ? 9 : 11,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  category,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: isCompact ? 9 : 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }

  /// Precio y stock en una sola línea
  Widget _buildPriceAndStock(bool isCompact) {
    final hasStock = widget.product.stockQuantity > 0;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '\$${widget.product.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isCompact ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A237E),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 3 : 5, 
            vertical: 2
          ),
          decoration: BoxDecoration(
            color: hasStock ? Colors.green[50] : Colors.red[50],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: hasStock ? Colors.green[200]! : Colors.red[200]!,
              width: 0.5,
            ),
          ),
          child: Text(
            hasStock ? 'Stock: ${widget.product.stockQuantity}' : 'Sin stock',
            style: TextStyle(
              color: hasStock ? Colors.green[700] : Colors.red[700],
              fontSize: isCompact ? 8 : 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Sección compacta para agregar al carrito
  Widget _buildAddToCartSection(bool isCompact) {
    final hasStock = widget.product.stockQuantity > 0;
    final buttonHeight = isCompact ? 22.0 : 26.0;
    
    if (!hasStock) {
      return SizedBox(
        width: double.infinity,
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            'Sin stock',
            style: TextStyle(
              fontSize: isCompact ? 9 : 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        // Controles de cantidad
        Container(
          height: buttonHeight,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!, width: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              _buildQuantityButton(
                icon: Icons.remove,
                onPressed: _quantity > 1 ? _decrementQuantity : null,
                isCompact: isCompact,
              ),
              Container(
                width: isCompact ? 20 : 24,
                height: buttonHeight,
                alignment: Alignment.center,
                child: Text(
                  _quantity.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isCompact ? 10 : 11,
                  ),
                ),
              ),
              _buildQuantityButton(
                icon: Icons.add,
                onPressed: _quantity < widget.product.stockQuantity ? _incrementQuantity : null,
                isCompact: isCompact,
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        // Botón agregar
        Expanded(
          child: SizedBox(
            height: buttonHeight,
            child: ElevatedButton.icon(
              onPressed: () => widget.onAddToCart?.call(_quantity),
              icon: Icon(Icons.add_shopping_cart, size: isCompact ? 11 : 13),
              label: Text(
                'Agregar',
                style: TextStyle(
                  fontSize: isCompact ? 9 : 10, 
                  fontWeight: FontWeight.w600
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: isCompact ? 3 : 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Botón de cantidad helper
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isCompact,
  }) {
    final buttonSize = isCompact ? 20.0 : 24.0;
    
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: isCompact ? 11 : 13),
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          foregroundColor: onPressed != null ? const Color(0xFF1A237E) : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
