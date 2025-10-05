import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/brand_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/providers/inventory_providers.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/inventory/pages/edit_pages/edit_brand_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/inventory/widgets/brand_category_cart.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/inventory/widgets/inventory_reusable_widgets.dart';

class BrandsPage extends ConsumerStatefulWidget {
  const BrandsPage({super.key});

  @override
  ConsumerState<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends ConsumerState<BrandsPage> {
  Future<List<BrandModel>>? _brandsFuture;
  String _query = '';
  String _selectedCategoryId = '';
  final _categoryCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    _brandsFuture = _filterByCategory();
  }


  Future<List<BrandModel>> _filterByCategory() async {
    final repo = ref.read(inventoryBrandCategoryRepositoryProvider);
    if (_selectedCategoryId.isEmpty) {
      // Si no hay categoría seleccionada, obtener todas las marcas
      return repo.getAllBrands();
    } else {
      // Filtrar marcas por la categoría seleccionada
      return repo.getAllBrandsByCategoryId(_selectedCategoryId);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _brandsFuture = _filterByCategory();
    });
    await _brandsFuture;
  }

  List<BrandModel> _filter(List<BrandModel> list) {
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
    final crossAxisCount = width > 900 ? 4 : width > 600 ? 3 : 2;
    final cardHeight = 180.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Marcas'),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112), // Aumentar altura para ambos widgets
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                // Campo de búsqueda
                SizedBox(
                  height: 48, 
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar marcas...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.06),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                const SizedBox(height: 8),
                // Dropdown de categorías
                SizedBox(
                  height: 48, //  Altura fija
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: InventoryReusableWidgets.getCategoriesDropdown(
                      ref: ref,
                      context: context,
                      onError: (msg) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(msg)),
                        );
                      },
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }
                      
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Text(
                              'No hay categorías disponibles',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }
                      
                      if (snapshot.hasError) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }
                      
                      final categories = [
                        {'id': '', 'name': 'Todas las categorías'}, // Opción para mostrar todas
                        ...snapshot.data!
                      ];
                      
                      return DropdownButtonFormField<String>(
                        value: _selectedCategoryId.isEmpty ? '' : _selectedCategoryId,
                        decoration: InputDecoration(
                          labelText: 'Filtrar por categoría',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          prefixIcon: const Icon(Icons.category),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          isDense: true,
                        ),
                        items: categories.map((cat) {
                          return DropdownMenuItem<String>(
                            value: cat['id'],
                            child: Text(
                              cat['name'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value ?? '';
                            _categoryCtrl.text = value ?? '';
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<BrandModel>>(
          future: _brandsFuture,
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
                        Text('Cargando marcas...'),
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
                  Center(
                    child: Text('Error al cargar marcas: ${snapshot.error}'),
                  ),
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
                  const Center(child: Text('No se encontraron marcas')),
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
                final b = filtered[index];
                return BrandCategoryCard<BrandModel>(
                  item: b,
                  isBrand: true,
                  getName: (item) => item.name,
                  getDescription: (item) => item.description,
                  getImageUrl: (item) => item.imageUrl,
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => EditBrandPage(brand: b),
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
          // abrir formulario para crear marca (ajusta a tu navegación, p.ej. context.go('/create-brands'))
        },
        child: const Icon(Icons.add),
        tooltip: 'Crear marca',
      ),
    );
  }
}
