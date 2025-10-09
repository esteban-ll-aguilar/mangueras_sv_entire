import 'package:flutter/material.dart';

// Sidebar personalizado
class ShopProductsPageSidebar extends StatelessWidget {
  const ShopProductsPageSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _SidebarItem(
                    icon: Icons.home_outlined,
                    title: 'Ir a Inicio',
                    onTap: () {
                      Navigator.pop(context);
                      print('Ir a Inicio');
                    },
                  ),
                  _SidebarItem(
                    icon: Icons.category_outlined,
                    title: 'Ver Categorías',
                    onTap: () {
                      Navigator.pop(context);
                      print('Ir a Categorías');
                    },
                  ),
                  _SidebarItem(
                    icon: Icons.shopping_cart_checkout_outlined,
                    title: 'Ver mi Carrito',
                    onTap: () {
                      Navigator.pop(context);
                      print('Ir a Carrito');
                    },
                  ),
                  _SidebarItem(
                    icon: Icons.favorite_outline,
                    title: 'Mis productos Favoritos',
                    onTap: () {
                      Navigator.pop(context);
                      print('Ir a Favoritos');
                    },
                  ),
                  _SidebarItem(
                    icon: Icons.local_offer_outlined,
                    title: 'Ofertas',
                    badge: 'NUEVO',
                    badgeColor: Colors.orange,
                    onTap: () {
                      Navigator.pop(context);
                      print('Ir a Ofertas');
                    },
                  ),
                  const Divider(height: 32),
                 
                  _SidebarItem(
                    icon: Icons.help_outline,
                    title: 'Ayuda y Soporte',
                    onTap: () {
                      Navigator.pop(context);
                      print('Ir a Ayuda');
                    },
                  ),
                  _SidebarItem(
                    icon: Icons.info_outline,
                    title: 'Acerca de',
                    onTap: () {
                      Navigator.pop(context);
                      print('Ir a Acerca de');
                    },
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

// Item del Sidebar
class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.title,
    this.badge,
    this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor ?? Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: onTap,
      hoverColor: Colors.grey[100],
    );
  }
}