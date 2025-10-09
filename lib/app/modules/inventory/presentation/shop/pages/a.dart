import 'package:flutter/material.dart';



class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String selectedCategory = 'Todos';
  String? selectedBrand;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;
    final isTablet = size.width > 600 && size.width <= 1024;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 40,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.store, color: Colors.red, size: 40),
            ),
            const SizedBox(width: 12),
            if (isDesktop)
              const Text(
                'Mi Tienda',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
          ],
        ),
        actions: [
          if (isDesktop) ...[
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.flash_on),
              label: const Text('Envío Express'),
            ),
            TextButton(onPressed: () {}, child: const Text('Nuevos')),
            TextButton(onPressed: () {}, child: const Text('Seminuevos')),
            TextButton(onPressed: () {}, child: const Text('Ofertas')),
          ],
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: isDesktop ? null : _buildDrawer(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            SizedBox(
              width: 280,
              child: _buildSidebar(),
            ),
          Expanded(
            child: _buildProductGrid(isDesktop, isTablet),
          ),
        ],
      ),
    );
  }

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
              _buildCategoryItem('DESCARBONIZANTE', false),
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
        hintText: 'Buscar...',
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


  Widget _buildDrawer() {
    return Drawer(
      child: _buildSidebar(),
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
            if (isSelected)
              const Icon(Icons.check_box, color: Colors.red, size: 20)
            else
              const Icon(Icons.check_box_outline_blank, size: 20),
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

  Widget _buildProductGrid(bool isDesktop, bool isTablet) {
    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Todos los productos (36 productos)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.sort, size: 20),
                    label: const Text('Ordenar por'),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Limpiar filtros'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.75,
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
                    'assets/battery.png',
                    height: 140,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.battery_full, size: 80),
                  ),
                ),
              ),
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
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(
                    'Ref: ${product['code']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    product['stock']!.toString(),
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['price']!.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
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