import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/category_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/providers/inventory_providers.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/widgets/brand_category_cart.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/edit_pages/edit_category_page.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  Future<List<CategoryModel>>? _CategoriesFuture;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _CategoriesFuture = _fetchCategories();
  }

  Future<List<CategoryModel>> _fetchCategories() {
    final repo = ref.read(inventoryBrandCategoryRepositoryProvider);
    return repo.getAllCategories();
  }

  Future<void> _refresh() async {
    setState(() {
      _CategoriesFuture = _fetchCategories();
    });
    await _CategoriesFuture;
  }

  List<CategoryModel> _filter(List<CategoryModel> list) {
    if (_query.trim().isEmpty) return list;
    final q = _query.toLowerCase();
    return list.where((b) {
      final name = b.name.toLowerCase();
      final desc = (b.description ?? '').toLowerCase();
      return name.contains(q) || desc.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 900
        ? 4
        : width > 600
        ? 3
        : 2;
    final cardHeight = 180.0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => context.go('/home'),
          tooltip: 'Volver',
        ),
        title: const Text('Gestión de Categorías'),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar categorías...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white.withOpacity(0.06),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<CategoryModel>>(
          future: _CategoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Cargando categorías...'),
                      ],
                    ),
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 48),
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 12),
                  Center(child: Text('No se pudieron cargar las categorías.')),
                  const SizedBox(height: 12),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ),
                ],
              );
            }

            final data = snapshot.data ?? [];
            final filtered = _filter(data);

            if (filtered.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 48),
                  const Center(
                    child: Icon(
                      Icons.branding_watermark,
                      size: 64,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(child: Text('No se encontraron categorías')),
                  const SizedBox(height: 12),
                ],
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: cardHeight,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final c = filtered[index];
                return BrandCategoryCard<CategoryModel>(
                  item: c,
                  isBrand: false,
                  getName: (item) => item.name,
                  getDescription: (item) => item.description,
                  getImageUrl: (item) => item.imageUrl,
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => EditCategoryPage(category: c),
                    );
                    if (result == true) {
                      _refresh();
                    }
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // abrir formulario para crear categoría (ajusta a tu navegación, p.ej. context.go('/create-Categories'))
        },
        child: const Icon(Icons.add),
        tooltip: 'Crear categoría',
      ),
    );
  }
}
