import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/shop/infrastructure/providers/shop_providers.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/widgets/shop_products_page/shop_products_page_widgets.dart';


class ShopProductsPageAppbar extends StatelessWidget implements PreferredSizeWidget {

  final VoidCallback onMenuPressed;
  final bool isDesktop;

  const ShopProductsPageAppbar({Key? key, required this.onMenuPressed, required this.isDesktop}) : super(key: key);


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
                  child: _SearchProductsField(),
                ),
              ),
              const SizedBox(width: 16),
              
              // Botón Inicio
              if (!isDesktop)
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


class _SearchProductsField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar Marcas o Categorías...',
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: (value) {
        ref.read(shopFiltersProvider.notifier).setSearchQuery(value);
      },
    );
  }
}