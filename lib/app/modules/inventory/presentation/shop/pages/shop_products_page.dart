import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/shop/widgets/shop_products_page/shop_products_page_appbar.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/shop/widgets/shop_products_page/shop_products_page_widgets.dart';
import 'package:mangueras_sv_entire/core/core.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopProductsPage extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ShopProductsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ShopProductsPage> createState() => _ShopProductsPageState();
}

class _ShopProductsPageState extends ConsumerState<ShopProductsPage> {
  String selectedCategory = 'Todos';
  String? selectedBrand;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;
    final isTablet = size.width > 600 && size.width <= 1024;
    final isMobile = size.width <= 600;

    return Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: Colors.white,
      appBar: ShopProductsPageAppbar(
        onMenuPressed: () {
          widget.scaffoldKey.currentState?.openEndDrawer();
        },
      ),
      endDrawer: isDesktop ? null : Drawer(child: _buildSidebar()),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar para desktop
          if (isDesktop)
            SizedBox(
              width: 280,
              child: _buildSidebar(),
            ),
          // Contenido principal
          Expanded(
            child: _buildProductGrid(isDesktop, isTablet, isMobile),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          launchUrl(whatsappUri);
        },
        heroTag: 'whatsapp_fab',
        tooltip: 'Ver Carrito',
        backgroundColor: const Color(0xFF1A237E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: ShopProductsPageWidgets.appBarButton(
          icon: Icons.shopping_cart_outlined,
          badge: 3,
          onTap: () {
            print('Ir a Carrito');
          },
          color: Colors.white,
          iconSize: 26,
        ),
      ),
    );
  }

  // Sidebar con filtros
  Widget _buildSidebar() {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSearchField(),
          const SizedBox(height: 24),
          _buildFilterSection(
            title: 'Marcas',
            count: 46,
            children: [
              _buildBrandCheckbox('HAVOLINE'),
              _buildBrandCheckbox('URSA'),
              _buildBrandCheckbox('TEXACO'),
              _buildBrandCheckbox('CASTROL'),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: EdgeInsets.zero,
                ),
                child: const Text('Ver más'),
              ),
            ],
          ),
          const Divider(height: 32),
          _buildFilterSection(
            title: 'Categorías',
            count: 12,
            children: [
              _buildCategoryItem('ACEITES', false),
              _buildCategoryItem('ADITIVOS', false),
              _buildCategoryItem('BATERIAS', true),
              _buildCategoryItem('CONSUMIBLES VARIOS', false),
              _buildCategoryItem('FILTROS', false),
              _buildCategoryItem('HERRAMIENTAS', false),
              _buildCategoryItem('LIQUIDOS DE FRENOS', false),
              _buildCategoryItem('LLANTAS', false),
              _buildCategoryItem('AMORTIGUADORES', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar Filtros...',
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required int count,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '($count)',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildBrandCheckbox(String brand) {
    return CheckboxListTile(
      value: selectedBrand == brand,
      onChanged: (value) {
        setState(() {
          selectedBrand = value! ? brand : null;
        });
      },
      title: Text(brand),
      contentPadding: EdgeInsets.zero,
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildCategoryItem(String category, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? Colors.red : null,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                category,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.red : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Grid de productos
  Widget _buildProductGrid(bool isDesktop, bool isTablet, bool isMobile) {
    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

    return Column(
      children: [
        // Barra superior con información
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Todos los productos (36 productos)',
                  style: TextStyle(
                    fontSize: isDesktop ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (!isMobile)
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.sort, size: 20),
                      label: const Text('Ordenar'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedBrand = null;
                          selectedCategory = 'Todos';
                        });
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Limpiar filtros'),
                    ),
                  ],
                ),
            ],
          ),
        ),
        // Grid de productos
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 9,
            itemBuilder: (context, index) => _buildProductCard(index),
          ),
        ),
      ],
    );
  }

  // Card de producto
  Widget _buildProductCard(int index) {
    final products = [
      {
        'name': 'BAT MOTOREX 31GMS1 R/NORMAL 12 VOLTIOS',
        'code': 'STB0313',
        'price': '\$788.57 + IVA',
        'stock': 'Stock Local (623)',
        'discount': '-40%',
        'hasExpress': true,
      },
      {
        'name': 'BAT MOTOREX 31GMS1 L/LIQUID 12 VOLTIOS',
        'code': 'STB2215',
        'price': '\$1115.28',
        'stock': 'Stock Local (770)',
        'discount': '',
        'hasExpress': false,
      },
      {
        'name': 'BAT MOTOREX 40D20L M/KS 12V 390A CA',
        'code': 'GBP4015',
        'price': '\$1115.28',
        'stock': 'Stock Local (411)',
        'discount': '-40%',
        'hasExpress': true,
      },
    ];

    final product = products[index % products.length];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          Stack(
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/logo.png',
                    height: 100,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.battery_full, size: 80),
                  ),
                ),
              ),
              // Badge de descuento
              if (product['discount'].toString().isNotEmpty)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product['discount']!.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              // Botón favorito
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, size: 20),
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ),
              // Badge de envío express
              if (product['hasExpress'] as bool)
                Positioned(
                  top: 8,
                  right: 48,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.flash_on,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          // Información del producto
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge de unidad
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '1 UND',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Nombre del producto
                  Text(
                    product['name']!.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Código de referencia
                  Text(
                    'Ref: ${product['code']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  // Stock
                  Text(
                    product['stock']!.toString(),
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Precio
                  Text(
                    product['price']!.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Botón agregar al carrito
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                      label: const Text('Agregar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
