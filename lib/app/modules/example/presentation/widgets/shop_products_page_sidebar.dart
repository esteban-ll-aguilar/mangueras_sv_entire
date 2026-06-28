import 'package:flutter/material.dart';

// Sidebar personalizado
class ExamplePageSidebar extends StatelessWidget {
  const ExamplePageSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header del Sidebar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[700]!, Colors.blue[500]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Juan Pérez',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'juan@ejemplo.com',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Opciones del menú
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _SidebarItem(
                    icon: Icons.person_outline,
                    title: 'Mi Perfil',
                    onTap: () {
                      Navigator.pop(context);
                      print('Ir a Perfil');
                    },
                  ),
                  _SidebarItem(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Mis Pedidos',
                    badge: '5',
                    onTap: () {
                      Navigator.pop(context);
                      print('Ir a Pedidos');
                    },
                  ),
                  _SidebarItem(
                    icon: Icons.favorite_outline,
                    title: 'Favoritos',
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
                    icon: Icons.settings_outlined,
                    title: 'Configuración',
                    onTap: () {
                      Navigator.pop(context);
                      print('Ir a Configuración');
                    },
                  ),
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
            
            // Footer - Botón cerrar sesión
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    print('Cerrar Sesión');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar Sesión'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.shade300),
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