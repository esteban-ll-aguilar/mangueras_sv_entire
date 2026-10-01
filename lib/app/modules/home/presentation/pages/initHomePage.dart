import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangueras_sv_entire/app/modules/auth/infrastructure/providers/authProvider.dart';

class InitHomePage extends ConsumerWidget {
  const InitHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isAdmin =
        authState is AuthStateAuthenticated && authState.isAdmin;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 900;
    final isTablet = size.width > 600 && size.width <= 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isWeb ? 40 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Panel de Control',
              style: GoogleFonts.poppins(
                fontSize: isWeb ? 32 : 28,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Gestión de inventario y productos',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            if (isAdmin) ...[
              SizedBox(height: isWeb ? 40 : 32),

              // Sección de Creación (solo admin)
              _buildSectionTitle('Creación de Nuevos Datos'),
              const SizedBox(height: 16),
              _buildGridSection(
                isWeb: isWeb,
                isTablet: isTablet,
                cards: [
                  _CardData(
                    icon: Icons.category_outlined,
                    title: 'Añadir Categorías',
                    subtitle: 'Crear nuevas categorías de productos',
                    route: '/create-categories',
                  ),
                  _CardData(
                    icon: Icons.label_outline,
                    title: 'Añadir Marcas',
                    subtitle: 'Registrar nuevas marcas de productos',
                    route: '/create-brands',
                  ),
                  _CardData(
                    icon: Icons.inventory_2_outlined,
                    title: 'Añadir Productos',
                    subtitle: 'Agregar nuevos productos al inventario',
                    route: '/create-products',
                  ),
                ],
              ),

              SizedBox(height: isWeb ? 48 : 32),

              // Sección de Gestión (solo admin)
              _buildSectionTitle('Gestión de Datos'),
              const SizedBox(height: 16),
              _buildGridSection(
                isWeb: isWeb,
                isTablet: isTablet,
                cards: [
                  _CardData(
                    icon: Icons.grid_view_outlined,
                    title: 'Gestionar Categorías',
                    subtitle: 'Ver, editar o eliminar categorías',
                    route: '/categories',
                  ),
                  _CardData(
                    icon: Icons.bookmark_border,
                    title: 'Gestionar Marcas',
                    subtitle: 'Administrar marcas registradas',
                    route: '/brands',
                  ),
                  _CardData(
                    icon: Icons.inventory_outlined,
                    title: 'Gestionar Productos',
                    subtitle: 'Administrar inventario completo',
                    route: '/products',
                  ),
                ],
              ),
            ],

            SizedBox(height: isWeb ? 48 : 32),

            // Sección de Pedidos (todos ven Mis Pedidos, solo admin ve pendientes)
            _buildSectionTitle('Pedidos'),
            const SizedBox(height: 16),
            _buildGridSection(
              isWeb: isWeb,
              isTablet: isTablet,
              cards: [
                _CardData(
                  icon: Icons.receipt_long_outlined,
                  title: 'Mis Pedidos',
                  subtitle: 'Carrito guardado y compras',
                  route: '/my-orders',
                ),
                if (isAdmin)
                  _CardData(
                    icon: Icons.sell_outlined,
                    title: 'Pedidos pendientes',
                    subtitle: 'Marcar vendido y descontar stock',
                    route: '/admin-orders',
                  ),
                if (!isAdmin)
                  _CardData(
                    icon: Icons.store_outlined,
                    title: 'Ver Tienda',
                    subtitle: 'Explorar productos',
                    route: '/shop/products',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildGridSection({
    required bool isWeb,
    required bool isTablet,
    required List<_CardData> cards,
  }) {
    final crossAxisCount = isWeb ? 3 : (isTablet ? 2 : 1);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isWeb ? 1.8 : (isTablet ? 1.6 : 2.2),
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return _buildProfessionalCard(
          icon: card.icon,
          title: card.title,
          subtitle: card.subtitle,
          onTap: () => context.go(card.route),
        );
      },
    );
  }

  Widget _buildProfessionalCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icono
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 28,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 16),
            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Flecha
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  _CardData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}