import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/product_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/providers/inventory_providers.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/pages/edit_pages/edit_product_page.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/widgets/product_card.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/widgets/inventory_reusable_widgets.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  Future<List<Map<String, dynamic>>>? _productsFuture; // Cambiar tipo
  String _query = '';
  String _selectedCategoryId = '';
  String _selectedBrandId = '';
  
  // Variables para filtros avanzados
  String _sortBy = 'name'; // 'name', 'price', 'stock', 'code'
  bool _sortAscending = true;
  double _minPrice = 0;
  double _maxPrice = double.infinity;
  bool _showOnlyInStock = false;
  bool _showOnlyActive = false;

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadProducts();
  }

  Future<List<Map<String, dynamic>>> _loadProducts() async {
    final repo = ref.read(inventoryProductRepositoryProvider);
    return repo.getAllProductsWithDetails(); // Usar el nuevo método
  }

  Future<void> _refresh() async {
    setState(() {
      _productsFuture = _loadProducts();
    });
    await _productsFuture;
  }

  List<Map<String, dynamic>> _filterProducts(List<Map<String, dynamic>> products) {
    var filtered = products;

    // Filtro por búsqueda
    if (_query.trim().isNotEmpty) {
      final q = _query.toLowerCase();
      filtered = filtered.where((p) {
        final name = (p['name'] ?? '').toString().toLowerCase();
        final description = (p['description'] ?? '').toString().toLowerCase();
        final code = (p['code'] ?? '').toString().toLowerCase();
        return name.contains(q) || description.contains(q) || code.contains(q);
      }).toList();
    }

    // CORRECCIÓN: Filtro por categoría usando la información completa
    if (_selectedCategoryId.isNotEmpty) {
      filtered = filtered.where((p) {
        final brandCategory = p['brand_category'];
        if (brandCategory != null) {
          return brandCategory['category_id'] == _selectedCategoryId;
        }
        return false;
      }).toList();
    }

    // CORRECCIÓN: Filtro por marca usando la información completa
    if (_selectedBrandId.isNotEmpty) {
      filtered = filtered.where((p) {
        final brandCategory = p['brand_category'];
        if (brandCategory != null) {
          return brandCategory['brand_id'] == _selectedBrandId;
        }
        return false;
      }).toList();
    }

    // Filtro por precio
    filtered = filtered.where((p) {
      final price = (p['price'] ?? 0).toDouble();
      return price >= _minPrice && price <= _maxPrice;
    }).toList();

    // Filtro por stock
    if (_showOnlyInStock) {
      filtered = filtered.where((p) => ((p['stock_quantity'] ?? 0) as int) > 0).toList();
    }

    // Filtro por activos
    if (_showOnlyActive) {
      filtered = filtered.where((p) => (p['is_active'] ?? false) == true).toList();
    }

    // CORRECCIÓN: Ordenamiento actualizado
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'name':
          comparison = (a['name'] ?? '').toString().compareTo((b['name'] ?? '').toString());
          break;
        case 'price':
          comparison = ((a['price'] ?? 0) as num).compareTo((b['price'] ?? 0) as num);
          break;
        case 'stock':
          comparison = ((a['stock_quantity'] ?? 0) as int).compareTo((b['stock_quantity'] ?? 0) as int);
          break;
        case 'code':
          comparison = (a['code'] ?? '').toString().compareTo((b['code'] ?? '').toString());
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  int get _activeFiltersCount {
    int count = 0;
    if (_selectedCategoryId.isNotEmpty) count++;
    if (_selectedBrandId.isNotEmpty) count++;
    if (_sortBy != 'name') count++;
    if (!_sortAscending) count++;
    if (_minPrice > 0) count++;
    if (_maxPrice < double.infinity) count++;
    if (_showOnlyInStock) count++;
    if (_showOnlyActive) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1200 ? 4 : width > 800 ? 3 : width > 500 ? 2 : 1;
    
    // Altura adaptativa según el ancho de pantalla
    final cardHeight = width > 800 ? 300.0 : width > 500 ? 280.0 : 250.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Productos'),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(160),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Campo de búsqueda
                _buildSearchField(),
                const SizedBox(height: 8),
                
                // Filtros por categoría y marca
                Row(
                  children: [
                    Expanded(child: _buildCategoryFilter()),
                    const SizedBox(width: 8),
                    Expanded(child: _buildBrandFilter()),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Botones de filtros y ordenamiento
                _buildFilterButtons(),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            }

            final products = snapshot.data ?? [];
            final filteredProducts = _filterProducts(products);

            if (filteredProducts.isEmpty) {
              return _buildEmptyState();
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: cardHeight, // Altura adaptativa
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final productData = filteredProducts[index];
                final product = ProductModel.fromJson(productData);
                
                return ProductCard(
                  product: product,
                  brandName: _getBrandName(productData),
                  categoryName: _getCategoryName(productData),
                  onTap: () => _editProduct(product),
                  onToggleActive: () => _toggleProductStatus(product),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a crear producto
          Navigator.pushNamed(context, '/create-product');
        },
        child: const Icon(Icons.add),
        tooltip: 'Crear producto',
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar productos por nombre, código o descripción...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
      onChanged: (value) => setState(() => _query = value),
    );
  }

  Widget _buildCategoryFilter() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: InventoryReusableWidgets.getCategoriesDropdown(
        ref: ref,
        context: context,
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildDropdownLoading('Categorías');
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildDropdownEmpty('Sin categorías');
        }

        final categories = [
          {'id': '', 'name': 'Todas las categorías'},
          ...snapshot.data!
        ];

        return DropdownButtonFormField<String>(
          value: _selectedCategoryId.isEmpty ? '' : _selectedCategoryId,
          decoration: InputDecoration(
            labelText: 'Categoría',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.category, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            isDense: true,
          ),
          isExpanded: true,
          items: categories.map((cat) {
            return DropdownMenuItem<String>(
              value: cat['id'],
              child: Text(
                cat['name'],
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategoryId = value ?? '';
              // IMPORTANTE: Limpiar la marca cuando cambie la categoría
              _selectedBrandId = '';
            });
          },
        );
      },
    );
  }

  Widget _buildBrandFilter() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _selectedCategoryId.isEmpty 
          ? Future.value(<Map<String, dynamic>>[]) // Si no hay categoría seleccionada, no mostrar marcas
          : InventoryReusableWidgets.getBrandsByCategoryDropdown( // Necesitarás crear este método
              ref: ref,
              context: context,
              categoryId: _selectedCategoryId,
              onError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error)),
                );
              },
            ),
      builder: (context, snapshot) {
        if (_selectedCategoryId.isEmpty) {
          return _buildDropdownDisabled('Selecciona una categoría primero');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildDropdownLoading('Marcas');
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildDropdownEmpty('Sin marcas para esta categoría');
        }

        final brands = [
          {'id': '', 'name': 'Todas las marcas'},
          ...snapshot.data!
        ];

        return DropdownButtonFormField<String>(
          value: _selectedBrandId.isEmpty ? '' : _selectedBrandId,
          decoration: InputDecoration(
            labelText: 'Marca',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.branding_watermark, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            isDense: true,
          ),
          isExpanded: true,
          items: brands.map((brand) {
            return DropdownMenuItem<String>(
              value: brand['id'],
              child: Text(
                brand['name'],
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedBrandId = value ?? '');
          },
        );
      },
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
        // Botón de ordenamiento
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _showSortDialog,
            icon: const Icon(Icons.sort, size: 16),
            label: Text(_getSortText(), style: const TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            ),
          ),
        ),
        const SizedBox(width: 8),
        
        // Botón de filtros avanzados
        OutlinedButton.icon(
          onPressed: _showAdvancedFiltersDialog,
          icon: Icon(
            Icons.filter_alt,
            size: 16,
            color: _activeFiltersCount > 0 ? Theme.of(context).primaryColor : null,
          ),
          label: Text(
            _activeFiltersCount > 0 ? 'Filtros ($_activeFiltersCount)' : 'Filtros',
            style: const TextStyle(fontSize: 12),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            side: _activeFiltersCount > 0 
                ? BorderSide(color: Theme.of(context).primaryColor)
                : null,
          ),
        ),
        const SizedBox(width: 8),
        
        // Botón de limpiar filtros
        if (_activeFiltersCount > 0)
          OutlinedButton(
            onPressed: _clearAllFilters,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(6),
              minimumSize: const Size(32, 32),
            ),
            child: const Icon(Icons.clear, size: 16),
          ),
      ],
    );
  }

  Widget _buildDropdownLoading(String label) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.category, size: 20, color: Colors.grey),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.grey)),
            const Spacer(),
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownEmpty(String message) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(message, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildDropdownDisabled(String message) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
      ),
      child: Center(
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(Icons.branding_watermark, size: 20, color: Colors.grey.shade400),
            const SizedBox(width: 8),
            Text(
              message, 
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Cargando productos...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text('Error al cargar productos'),
          const SizedBox(height: 8),
          Text(error, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text('No se encontraron productos'),
          if (_activeFiltersCount > 0) ...[
            const SizedBox(height: 8),
            const Text('Intenta ajustar los filtros'),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _clearAllFilters,
              icon: const Icon(Icons.clear),
              label: const Text('Limpiar filtros'),
            ),
          ],
        ],
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ordenar productos'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Nombre'),
                value: 'name',
                groupValue: _sortBy,
                onChanged: (value) => setDialogState(() => _sortBy = value!),
              ),
              RadioListTile<String>(
                title: const Text('Precio'),
                value: 'price',
                groupValue: _sortBy,
                onChanged: (value) => setDialogState(() => _sortBy = value!),
              ),
              RadioListTile<String>(
                title: const Text('Stock'),
                value: 'stock',
                groupValue: _sortBy,
                onChanged: (value) => setDialogState(() => _sortBy = value!),
              ),
              RadioListTile<String>(
                title: const Text('Código'), // Cambiar "Fecha de creación" por "Código"
                value: 'code',
                groupValue: _sortBy,
                onChanged: (value) => setDialogState(() => _sortBy = value!),
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('Orden descendente'),
                value: !_sortAscending,
                onChanged: (value) => setDialogState(() => _sortAscending = !value),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  void _showAdvancedFiltersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtros avanzados'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Solo productos en stock'),
                  value: _showOnlyInStock,
                  onChanged: (value) => setDialogState(() => _showOnlyInStock = value),
                ),
                SwitchListTile(
                  title: const Text('Solo productos activos'),
                  value: _showOnlyActive,
                  onChanged: (value) => setDialogState(() => _showOnlyActive = value),
                ),
                const Divider(),
                const Text('Rango de precios'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Precio mínimo',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final price = double.tryParse(value) ?? 0;
                          setDialogState(() => _minPrice = price);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Precio máximo',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final price = double.tryParse(value);
                          setDialogState(() => _maxPrice = price ?? double.infinity);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _minPrice = 0;
                _maxPrice = double.infinity;
                _showOnlyInStock = false;
                _showOnlyActive = true;
              });
            },
            child: const Text('Limpiar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  String _getSortText() {
    String text = '';
    switch (_sortBy) {
      case 'name': text = 'Nombre'; break;
      case 'price': text = 'Precio'; break;
      case 'stock': text = 'Stock'; break;
      case 'code': text = 'Código'; break; // Cambiar 'date' por 'code'
    }
    return '$text ${_sortAscending ? '↑' : '↓'}';
  }

  void _clearAllFilters() {
    setState(() {
      _query = '';
      _selectedCategoryId = '';
      _selectedBrandId = '';
      _sortBy = 'name';
      _sortAscending = true;
      _minPrice = 0;
      _maxPrice = double.infinity;
      _showOnlyInStock = false;
      _showOnlyActive = true;
    });
  }

  Future<void> _editProduct(ProductModel product) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => EditProductPage(product: product),
    );
    
    if (result == true) {
      _refresh();
    }
  }

  Future<void> _toggleProductStatus(ProductModel product) async {
    try {
      final repo = ref.read(inventoryProductRepositoryProvider);
      await repo.updateProduct(
        product.code,
        {'is_active': !product.isActive},
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            product.isActive 
                ? 'Producto desactivado' 
                : 'Producto activado'
          ),
        ),
      );
      
      _refresh();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cambiar estado: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // NUEVO: Métodos para verificar pertenencia a categoría/marca
  bool _productBelongsToCategory(ProductModel product, String categoryId) {
    // Aquí necesitamos verificar si el brandCategoryId del producto
    // corresponde a una asociación que incluya esta categoría
    // Por ahora retornamos true, pero necesitaremos implementar la lógica
    return true; // TODO: Implementar lógica real
  }

  bool _productBelongsTobrand(ProductModel product, String brandId) {
    // Aquí necesitamos verificar si el brandCategoryId del producto
    // corresponde a una asociación que incluya esta marca
    // Por ahora retornamos true, pero necesitaremos implementar la lógica
    return true; // TODO: Implementar lógica real
  }

  // NUEVO: Métodos helper para obtener nombres
  String _getBrandName(Map<String, dynamic> productData) {
    final brandCategory = productData['brand_category'];
    if (brandCategory != null && brandCategory['brand'] != null) {
      return brandCategory['brand']['name'] ?? 'Sin marca';
    }
    return 'Sin marca';
  }

  String _getCategoryName(Map<String, dynamic> productData) {
    final brandCategory = productData['brand_category'];
    if (brandCategory != null && brandCategory['category'] != null) {
      return brandCategory['category']['name'] ?? 'Sin categoría';
    }
    return 'Sin categoría';
  }
}