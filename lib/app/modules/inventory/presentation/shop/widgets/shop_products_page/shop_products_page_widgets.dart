import 'package:flutter/material.dart';

class ShopProductsPageWidgets {
  ShopProductsPageWidgets._();

  static Widget appBarButton({
    required IconData icon,
    String? label,
    int? badge,
    required VoidCallback onTap,
    Color? color,
    int iconSize = 24,
  }) {
    return _AppBarButton(
      icon: icon,
      label: label,
      badge: badge,
      onTap: onTap,
      color: color,
      iconSize: iconSize,
    );
  }
}




















// Widget reutilizable para botones del AppBar
class _AppBarButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final int? badge;
  final VoidCallback onTap;
  final Color? color;
  final int iconSize;

  const _AppBarButton({
    required this.icon,
    this.label,
    this.badge,
    required this.onTap,
    this.color,
    this.iconSize = 24,

  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center, // centrar verticalmente
              children: [
                Icon(icon, size: iconSize.toDouble(), color: color ?? Colors.black87),
                const SizedBox(height: 2),
                if (label != null)
                  Flexible(
                    // permitir que el texto se reduzca / trunque en una sola línea
                    child: Text(
                      label!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: color ?? Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            if (badge != null && badge! > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    badge! > 9 ? '9+' : badge.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}