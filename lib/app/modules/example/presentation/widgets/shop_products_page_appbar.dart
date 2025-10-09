import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/shop/widgets/shop_products_page/shop_products_page_widgets.dart';






class ExamplePageAppbar extends StatelessWidget implements PreferredSizeWidget {

  final VoidCallback onMenuPressed;

  const ExamplePageAppbar({Key? key, required this.onMenuPressed}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
            spreadRadius: 2,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              // Logo
              Image.asset(
                'assets/logo.png', // Cambia por tu ruta
                height: 70,
                width: 70,
              ),
              
              // Barra de búsqueda
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar productos...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[600],
                        size: 22,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      // Implementa tu lógica de búsqueda
                      print('Buscando: $value');
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Botón Inicio
              // if (kIsWeb)
              //   ShopProductsPageWidgets.appBarButton(
              //     icon: Icons.home_outlined,
              //     label: 'Inicio',
              //     onTap: () {
              //       context.go('/');
              //     },
              //     color: Colors.white,
              //   ),

              ShopProductsPageWidgets.appBarButton(
                  icon: Icons.menu,
                  onTap: () {
                    onMenuPressed();
                  },
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}





Widget _sidebarButton({
  required IconData icon,
  String? label,
  int? badge,
  required VoidCallback onTap,
  Color? color,
  double iconSize = 24,
}) {
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
          if (badge != null && badge > 0)
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
                  badge > 9 ? '9+' : badge.toString(),
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