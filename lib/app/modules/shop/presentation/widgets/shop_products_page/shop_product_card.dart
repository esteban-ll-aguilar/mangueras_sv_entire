import 'package:flutter/material.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/widgets/shop_products_page/expandable_text.dart';

/// Widget que muestra una tarjeta de producto con su información
class ShopProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final Function(int quantity)? onAddToCart;
  final VoidCallback? onToggleFavorite;
  final bool isFavorite;

  const ShopProductCard({
    Key? key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.onToggleFavorite,
    this.isFavorite = false,
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductName(),
                    const SizedBox(height: 4),
                    _buildProductCode(),
                    const SizedBox(height: 4),
                    _buildProductDescription(),
                    const SizedBox(height: 4),
                    const Divider(),
                    const SizedBox(height: 4),
                    _buildStockInfo(),
                    const SizedBox(height: 4),
                    _buildPrice(),
                    const SizedBox(height: 8),
                    _buildAddToCartButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Imagen del producto con badges
  Widget _buildProductImage() {
    return Stack(
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: widget.product.imageUrl != null && widget.product.imageUrl!.isNotEmpty
                ? Image.network(
                    widget.product.imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const CircularProgressIndicator();
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.inventory_2, size: 80, color: Colors.grey),
                  )
                : const Icon(Icons.inventory_2, size: 80, color: Colors.grey),
          ),
        // Botón favorito
        // Positioned(
        //   top: 8,
        //   right: 8,
        //   child: IconButton(
        //     icon: Icon(
        //       widget.isFavorite ? Icons.favorite : Icons.favorite_border,
        //       size: 20,
        //       color: widget.isFavorite ? Colors.red : null,
        //     ),
        //     onPressed: widget.onToggleFavorite,
        //     style: IconButton.styleFrom(
        //       backgroundColor: Colors.white,
        //       padding: const EdgeInsets.all(8),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  
  /// Nombre del producto
  Widget _buildProductName() {
    return Text(
      widget.product.name,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Código del producto
  Widget _buildProductCode() {
    return Text(
      'Ref: ${widget.product.code}',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 16,
      ),
    );
  }
  Widget _buildProductDescription() {
    return ExpandableText(
      widget.product.description ?? 'Sin descripción',
      maxLines: 1,
    );
  }

  /// Información de stock
  Widget _buildStockInfo() {
    final hasStock = widget.product.stockQuantity > 0;
    return Text(
      hasStock ? 'Stock Local (${widget.product.stockQuantity})' : 'Sin stock',
      style: TextStyle(
        color: hasStock ? Colors.green[700] : Colors.red[700],
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// Precio del producto
  Widget _buildPrice() {
    return Text(
      '\$${widget.product.price.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  /// Botón para agregar al carrito con selector de cantidad
  Widget _buildAddToCartButton() {
    final hasStock = widget.product.stockQuantity > 0;
    
    return Column(
      children: [
        // Selector de cantidad
        if (hasStock)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _decrementQuantity,
                icon: const Icon(Icons.remove_circle_outline),
                iconSize: 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  _quantity.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: _incrementQuantity,
                icon: const Icon(Icons.add_circle_outline),
                iconSize: 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        const SizedBox(height: 8),
        // Botón agregar
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: hasStock
                ? () => widget.onAddToCart?.call(_quantity)
                : null,
            icon: const Icon(Icons.shopping_cart_outlined, size: 18),
            label: Text(hasStock ? 'Agregar' : 'Sin stock'),
            style: ElevatedButton.styleFrom(
              backgroundColor: hasStock ? Colors.red : Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
