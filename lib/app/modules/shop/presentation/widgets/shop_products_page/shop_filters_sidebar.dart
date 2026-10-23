import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mangueras_sv_entire/app/modules/shop/infrastructure/providers/shop_providers.dart';
import 'package:mangueras_sv_entire/core/routes/app_router.dart';
import 'package:mangueras_sv_entire/core/utils/constants/constants.dart';

/// Widget del sidebar con filtros de marcas y categorías
class ShopFiltersSidebar extends ConsumerWidget {
  const ShopFiltersSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilters = ref.watch(shopFiltersProvider);
    final hasActiveFilters =
        selectedFilters.selectedBrandIds.isNotEmpty ||
        selectedFilters.selectedCategoryIds.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[50]!, Colors.white],
        ),
        border: Border(right: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: CustomScrollView(
        slivers: [
          // Header con acciones rápidas
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título principal
                  const Row(
                    children: [
                      Icon(Icons.menu_rounded, color: Colors.red, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Menú',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Acciones rápidas en una grilla
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 3.5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _QuickActionButton(
                        icon: Icons.home_rounded,
                        label: 'Inicio',
                        color: const Color(0xFF1A237E),
                        onTap: () =>
                            context.goNamed(AppRouteNames.shopWelcome.name),
                      ),
                      _QuickActionButton(
                        icon: Icons.shopping_cart_rounded,
                        label: 'Carrito',
                        color: Colors.orange,
                        onTap: () =>
                            context.goNamed(AppRouteNames.shopCart.name),
                      ),
                      _QuickActionButton(
                        icon: Icons.phone_rounded,
                        label: 'Llamar',
                        color: Colors.green,
                        onTap: () => launchUrl(phoneNumberUri),
                      ),
                      _QuickActionButton(
                        icon: Icons.chat_bubble_rounded,
                        label: 'WhatsApp',
                        color: const Color(0xFF25D366),
                        onTap: () => launchUrl(whatsappUri),
                      ),
                      _QuickActionButton(
                        icon: Icons.email_rounded,
                        label: 'Email',
                        color: Colors.blueAccent,
                        onTap: () => launchUrl(emailUri),
                      ),
                      _QuickActionButton(
                        icon: Icons.location_on_rounded,
                        label: 'Ubicación',
                        color: Colors.red,
                        onTap: () => launchUrl(locationUri),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),

                  // Título de filtros
                  Row(
                    children: [
                      const Icon(
                        Icons.tune_rounded,
                        color: Colors.red,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Filtros',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (hasActiveFilters)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Text(
                            'Activos',
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Botón limpiar filtros
                  if (hasActiveFilters)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ref.read(shopFiltersProvider.notifier).clearFilters();
                        },
                        icon: const Icon(Icons.clear_all_rounded, size: 18),
                        label: const Text('Limpiar Filtros'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Contenido con padding
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8), // Pequeño espacio desde el header

                _CategoryFilters(),
                const SizedBox(height: 20),
                _BrandFilters(),
                const SizedBox(height: 40), // Espacio para el botón flotante
                // Footer informativo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A237E).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF1A237E).withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: const Color(0xFF1A237E).withOpacity(0.7),
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Mangueras SV',
                        style: TextStyle(
                          color: const Color(0xFF1A237E),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Repuestos de calidad desde 2009',
                        style: TextStyle(
                          color: const Color(0xFF1A237E).withOpacity(0.7),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80), // Extra space at bottom
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sección de filtros por marca
class _BrandFilters extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsAsync = ref.watch(shopBrandsProvider);
    final selectedBrandIds = ref.watch(shopFiltersProvider).selectedBrandIds;

    return brandsAsync.when(
      data: (brands) {
        // Mostrar solo las primeras 4 marcas por defecto
        final visibleBrands = brands.take(4).toList();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FilterSectionHeader(
                title: 'Marcas',
                count: brands.length,
                selectedCount: selectedBrandIds.length,
              ),
              const SizedBox(height: 16),
              ...visibleBrands.map((brand) {
                final isSelected = selectedBrandIds.contains(brand.id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _FilterItem(
                    title: brand.name,
                    isSelected: isSelected,
                    onTap: () {
                      ref
                          .read(shopFiltersProvider.notifier)
                          .toggleBrandFilter(brand.id);
                    },
                  ),
                );
              }).toList(),
              if (brands.length > 4)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () {
                        // TODO: Mostrar todas las marcas en un dialog
                        _showAllBrandsDialog(context, ref, brands);
                      },
                      icon: const Icon(Icons.expand_more, size: 18),
                      label: Text('Ver todas (${brands.length})'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.red[200]!),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const _LoadingCard(title: 'Marcas'),
<<<<<<< HEAD
      // Fase 3: genérico, sin error.toString().
      error: (_, __) => const _ErrorCard(title: 'Marcas'),
=======
      error: (error, stack) => const _ErrorCard(
        title: 'Marcas',
        error: 'No se pudieron cargar las marcas.',
      ),
>>>>>>> 66286d4 (feat: enhance error handling and UI feedback across inventory and shop modules)
    );
  }

  void _showAllBrandsDialog(BuildContext context, WidgetRef ref, List brands) {
    final selectedBrandIds = ref.read(shopFiltersProvider).selectedBrandIds;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.branding_watermark, color: Colors.red),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Todas las Marcas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
              Expanded(
                child: ListView.builder(
                  itemCount: brands.length,
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    final isSelected = selectedBrandIds.contains(brand.id);
                    return _FilterItem(
                      title: brand.name,
                      isSelected: isSelected,
                      onTap: () {
                        ref
                            .read(shopFiltersProvider.notifier)
                            .toggleBrandFilter(brand.id);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sección de filtros por categoría
class _CategoryFilters extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(shopCategoriesProvider);
    final selectedCategoryIds = ref
        .watch(shopFiltersProvider)
        .selectedCategoryIds;

    return categoriesAsync.when(
      data: (categories) {
        // Filtrar solo categorías principales
        final mainCategories = categories.toList();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FilterSectionHeader(
                title: 'Categorías',
                count: mainCategories.length,
                selectedCount: selectedCategoryIds.length,
              ),
              const SizedBox(height: 16),
              ...mainCategories.map((category) {
                final isSelected = selectedCategoryIds.contains(category.id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _FilterItem(
                    title: category.name,
                    isSelected: isSelected,
                    onTap: () {
                      ref
                          .read(shopFiltersProvider.notifier)
                          .toggleCategoryFilter(category.id);
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
      loading: () => const _LoadingCard(title: 'Categorías'),
<<<<<<< HEAD
      // Fase 3: genérico, sin error.toString().
      error: (_, __) => const _ErrorCard(title: 'Categorías'),
=======
      error: (error, stack) => const _ErrorCard(
        title: 'Categorías',
        error: 'No se pudieron cargar las categorías.',
      ),
>>>>>>> 66286d4 (feat: enhance error handling and UI feedback across inventory and shop modules)
    );
  }
}

/// Header de sección de filtros
class _FilterSectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final int selectedCount;

  const _FilterSectionHeader({
    required this.title,
    required this.count,
    this.selectedCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          title == 'Marcas' ? Icons.branding_watermark : Icons.category,
          color: Colors.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        if (selectedCount > 0) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$selectedCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// Botón de acción rápida personalizado
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Item de filtro mejorado con animaciones
class _FilterItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? Colors.red.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.red.withOpacity(0.3) : Colors.transparent,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? Colors.red : Colors.grey[400]!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected ? Colors.red[700] : Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget de carga para filtros
class _LoadingCard extends StatelessWidget {
  final String title;

  const _LoadingCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                title == 'Marcas' ? Icons.branding_watermark : Icons.category,
                color: Colors.grey[400],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 12),
          Text(
            'Cargando $title...',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Widget de error para filtros (Fase 3: genérico, sin detalle técnico).
class _ErrorCard extends StatelessWidget {
  final String title;

  const _ErrorCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[600], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Error al cargar $title',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.red[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
<<<<<<< HEAD
            'Intenta de nuevo más tarde.',
            style: TextStyle(
              color: Colors.red[600],
              fontSize: 12,
            ),
=======
            error,
            style: TextStyle(color: Colors.red[600], fontSize: 12),
>>>>>>> 66286d4 (feat: enhance error handling and UI feedback across inventory and shop modules)
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
