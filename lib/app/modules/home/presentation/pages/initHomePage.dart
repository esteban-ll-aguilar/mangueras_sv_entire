import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/view_pages/view_brands_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/view_pages/view_categories_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/view_pages/view_products_page.dart';

class InitHomePage extends StatefulWidget {
  const InitHomePage({super.key});

  @override
  State<InitHomePage> createState() => _InitHomePageState();
}

class _InitHomePageState extends State<InitHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Sección de Cuenta
          _buildSectionHeader('Panel de Control - Creación de Nuevos Datos'),
          const SizedBox(height: 10),
          _buildListTile(
            icon: Icons.category_sharp,
            title: 'Añadir Categorias',
            subtitle: 'Añadir nuevas categorias de productos al sistema',
            onTap: () {
              context.go('/create-categories');
            },
          ),
          const SizedBox(height: 10),
          _buildListTile(
            icon: Icons.label,
            title: 'Añadir Marcas',
            subtitle: 'Añadir nuevas marcas de productos al sistema',
            onTap: () {
              context.go('/create-brands');
            },
          ),
          const SizedBox(height: 10),
          _buildListTile(
            icon: Icons.inventory_2,
            title: 'Añadir Productos',
            subtitle: 'Añadir nuevos productos al sistema',
            onTap: () {
              context.go('/create-products');
            },
          ),
          const SizedBox(height: 10),
          const Divider(),
           _buildSectionHeader('Panel de Control - Gestión de Datos'),
          const SizedBox(height: 10),

          _buildListTile(
            icon: Icons.category_sharp,
            title: 'Gestionar Categorias',
            subtitle: 'Ver, editar o eliminar categorias de productos',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesPage()));
            },
          ),
          const SizedBox(height: 10),
          _buildListTile(
            icon: Icons.label,
            title: 'Gestionar Marcas',
            subtitle: 'Ver, editar o eliminar marcas de productos',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const BrandsPage()));
            },
          ),
          const SizedBox(height: 10),
          _buildListTile(
            icon: Icons.inventory_2,
            title: 'Gestionar Productos',
            subtitle: 'Ver, editar o eliminar productos del sistema',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsPage()));
            },
          ),
    

        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  
}