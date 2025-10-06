import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class ShopWelcomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ShopWelcomePage> createState() => _ShopWelcomePageState();
}

class _ShopWelcomePageState extends ConsumerState<ShopWelcomePage> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _brandScrollController = ScrollController();
  Timer? _brandScrollTimer;
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _startBrandCarousel();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_showSearchBar) {
      setState(() => _showSearchBar = true);
    } else if (_scrollController.offset <= 100 && _showSearchBar) {
      setState(() => _showSearchBar = false);
    }
  }

  void _startBrandCarousel() {
    _brandScrollTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_brandScrollController.hasClients) {
        final maxScroll = _brandScrollController.position.maxScrollExtent;
        final currentScroll = _brandScrollController.offset;
        
        if (currentScroll >= maxScroll) {
          _brandScrollController.jumpTo(0);
        } else {
          _brandScrollController.animateTo(
            currentScroll + 1,
            duration: Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _brandScrollController.dispose();
    _brandScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1024;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Hero Section
              SliverToBoxAdapter(
                child: _buildHeroSection(context, isMobile, isTablet),
              ),
              
              // Stats Section
              SliverToBoxAdapter(
                child: _buildStatsSection(isMobile),
              ),

              // Categories Section
              SliverToBoxAdapter(
                child: _buildCategoriesSection(context, isMobile, isTablet),
              ),

              // Brands Carousel
              SliverToBoxAdapter(
                child: _buildBrandsCarousel(isMobile),
              ),

              // Services Section
              SliverToBoxAdapter(
                child: _buildServicesSection(isMobile, isTablet),
              ),

              // CTA Section
              SliverToBoxAdapter(
                child: _buildCTASection(isMobile),
              ),

              // Footer
              SliverToBoxAdapter(
                child: _buildFooter(isMobile),
              ),
            ],
          ),

          // Floating App Bar
          _buildFloatingAppBar(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildFloatingAppBar(BuildContext context, bool isMobile) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _showSearchBar ? 80 : 0,
      child: AnimatedOpacity(
        opacity: _showSearchBar ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 48, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset('assets/logo.png', height: 40),
              SizedBox(width: 12),
              if (!isMobile)
                Text(
                  'Mangueras SV',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
              Spacer(),
              Expanded(
                flex: isMobile ? 3 : 1,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar repuestos...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile, bool isTablet) {
    return Container(
      height: isMobile ? 600 : 700,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A237E),
            Color(0xFF0D47A1),
            Color(0xFF1565C0),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                painter: GridPatternPainter(),
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Column(
              children: [
                // Top Navigation
                Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 32),
                  child: Row(
                    children: [
                      Image.asset('assets/logo.png', height: isMobile ? 60 : 70),
                      SizedBox(width: 5),
                      Text(
                        'Mangueras SV',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 20 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      if (!isMobile) ...[
                        _navButton('Categorías'),
                        SizedBox(width: 24),
                        _navButton('Marcas'),
                        SizedBox(width: 24),
                        _navButton('Contacto'),
                        SizedBox(width: 24),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.shopping_cart),
                          label: Text('Cotizar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF1A237E),
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ] else
                        IconButton(
                          icon: Icon(Icons.menu, color: Colors.white),
                          onPressed: () {},
                        ),
                    ],
                  ),
                ),

                // Hero Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 48),
                    child: isMobile ? _heroContentMobile() : _heroContentDesktop(isTablet),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _heroContentMobile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Repuestos de Calidad',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Text(
          'Para Todo Tipo de Vehículos',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32),
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.white70),
                      SizedBox(width: 8),
                      Text(
                        'Buscar repuestos...',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.explore),
              label: Text('Explorar Catálogo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF1A237E),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.phone),
              label: Text('Contactar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white, width: 2),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _heroContentDesktop(bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Envíos a todo el país \uD83C\uDDEA\uD83C\uDDE8',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Repuestos de Calidad\nPara Todo Tipo\nde Vehículos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 42 : 56,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 24),
              Text(
                // 'Más de 10,000 productos en stock. Distribución\nautorizada de las mejores marcas del mercado.',
                'Múltiples productos disponibles para ti. Distribución\nautorizada de las mejores marcas del mercado.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  height: 1.6,
                ),
              ),
              SizedBox(height: 40),
              Container(
                constraints: BoxConstraints(maxWidth: 600),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar por código, marca o categoría...',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Buscar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1A237E),
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isTablet)
          Expanded(
            child: Center(
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.settings, size: 200, color: Colors.white.withOpacity(0.3)),
                    Positioned(
                      top: 50,
                      right: 50,
                      child: _floatingIcon(Icons.speed),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 50,
                      child: _floatingIcon(Icons.build),
                    ),
                    Positioned(
                      top: 150,
                      left: 30,
                      child: _floatingIcon(Icons.electric_bolt),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _floatingIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Icon(icon, color: Color(0xFF1A237E), size: 24),
    );
  }

  _buildStatsSection(bool isMobile) async {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 80, horizontal: isMobile ? 24 : 48),
      child: isMobile
          ? Column(
              children: [
                _statItem('10,000+', 'Productos', Icons.inventory_2),
                SizedBox(height: 32),
                _statItem('50+', 'Marcas', Icons.verified),
                SizedBox(height: 32),
                _statItem('15 años', 'Experiencia', Icons.emoji_events),
                SizedBox(height: 32),
                _statItem('24/7', 'Soporte', Icons.support_agent),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statItem('10,000+', 'Productos', Icons.inventory_2),
                _statItem('50+', 'Marcas', Icons.verified),
                _statItem('15 años', 'Experiencia', Icons.emoji_events),
                _statItem('24/7', 'Soporte', Icons.support_agent),
              ],
            ),
    );
  }

  Widget _statItem(String number, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF1A237E).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFF1A237E), size: 32),
        ),
        SizedBox(height: 16),
        Text(
          number,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(BuildContext context, bool isMobile, bool isTablet) {
    final categories = [
      {'icon': Icons.settings, 'name': 'Motor', 'count': '2,500+', 'color': Color(0xFFE53935)},
      {'icon': Icons.speed, 'name': 'Frenos', 'count': '1,800+', 'color': Color(0xFF1E88E5)},
      {'icon': Icons.wb_incandescent, 'name': 'Eléctrico', 'count': '3,200+', 'color': Color(0xFFFB8C00)},
      {'icon': Icons.air, 'name': 'Suspensión', 'count': '1,500+', 'color': Color(0xFF43A047)},
      {'icon': Icons.water_drop, 'name': 'Aceites', 'count': '800+', 'color': Color(0xFF8E24AA)},
      {'icon': Icons.car_repair, 'name': 'Transmisión', 'count': '1,200+', 'color': Color(0xFF00ACC1)},
    ];

    final crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 3);

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 80, horizontal: isMobile ? 24 : 48),
      color: Colors.grey[50],
      child: Column(
        children: [
          Text(
            'Categorías Principales',
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Explora nuestra amplia gama de repuestos',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 32 : 48),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isMobile ? 0.85 : 1,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _categoryCard(
                category['icon'] as IconData,
                category['name'] as String,
                category['count'] as String,
                category['color'] as Color,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(IconData icon, String name, String count, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 40, color: color),
                ),
                SizedBox(height: 16),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandsCarousel(bool isMobile) {
    final brands = [
      'Bosch', 'Monroe', 'NGK', 'Castrol', 'Mobil', 
      'Valvoline', 'ACDelco', 'Denso', 'Mann Filter', 'Brembo',
      'SKF', 'Gates', 'Continental', 'Michelin', 'Bridgestone'
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 60),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Marcas Autorizadas',
            style: TextStyle(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
          SizedBox(height: isMobile ? 24 : 40),
          SizedBox(
            height: 80,
            child: ListView.builder(
              controller: _brandScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: brands.length * 100,
              itemBuilder: (context, index) {
                final brand = brands[index % brands.length];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Center(
                    child: Text(
                      brand,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(bool isMobile, bool isTablet) {
    final services = [
      {
        'icon': Icons.local_shipping,
        'title': 'Envío Rápido',
        'description': 'Entregas en 24-48 horas a nivel nacional',
      },
      {
        'icon': Icons.verified_user,
        'title': 'Garantía Total',
        'description': 'Todos nuestros productos certificados',
      },
      {
        'icon': Icons.support_agent,
        'title': 'Asesoría Técnica',
        'description': 'Expertos disponibles para ayudarte',
      },
      {
        'icon': Icons.price_check,
        'title': 'Mejores Precios',
        'description': 'Precios competitivos garantizados',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 80, horizontal: isMobile ? 24 : 48),
      child: Column(
        children: [
          Text(
            '¿Por Qué Elegirnos?',
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 32 : 48),
          isMobile
              ? Column(
                  children: services.map((s) => Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: _serviceCard(s['icon'] as IconData, s['title'] as String, s['description'] as String),
                  )).toList(),
                )
              : Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: services.map((s) => SizedBox(
                    width: isTablet ? MediaQuery.of(context).size.width / 2 - 58 : MediaQuery.of(context).size.width / 4 - 63,
                    child: _serviceCard(s['icon'] as IconData, s['title'] as String, s['description'] as String),
                  )).toList(),
                ),
        ],
      ),
    );
  }

  Widget _serviceCard(IconData icon, String title, String description) {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Color(0xFF1A237E)),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(bool isMobile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 48, vertical: isMobile ? 40 : 80),
      padding: EdgeInsets.all(isMobile ? 32 : 64),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF1565C0)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            '¿Listo para encontrar tus repuestos?',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 24 : 36,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Contáctanos hoy y recibe asesoría personalizada',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.phone),
                label: Text('Llamar Ahora'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF1A237E),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.email),
                label: Text('Enviar Email'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white, width: 2),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 32 : 48),
      color: Color(0xFF1A237E),
      child: Column(
        children: [
          if (!isMobile)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/logo.png', height: 45),
                          SizedBox(width: 5),
                          Text(
                            'Mangueras SV',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tu socio confiable en repuestos\nautomotrices desde 2009.',
                        style: TextStyle(color: Colors.white70, height: 1.6),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enlaces Rápidos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _footerLink('Sobre Nosotros'),
                      _footerLink('Catálogo'),
                      _footerLink('Marcas'),
                      _footerLink('Blog'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contacto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _footerContact(Icons.phone, '+593 99 123 4567'),
                      _footerContact(Icons.email, 'info@autopartspro.com'),
                      _footerContact(Icons.location_on, 'Guayaquil, Ecuador'),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                Icon(Icons.build_circle, color: Colors.white, size: 40),
                SizedBox(height: 16),
                Text(
                  'Mangueras SV',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                _footerContact(Icons.phone, '+593 99 123 4567'),
                _footerContact(Icons.email, 'info@autopartspro.com'),
                _footerContact(Icons.location_on, 'Guayaquil, Ecuador'),
              ],
            ),
          SizedBox(height: 32),
          Divider(color: Colors.white24),
          SizedBox(height: 24),
          Text(
            '© 2024 AutoParts Pro. Todos los derechos reservados.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {},
        child: Text(
          text,
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _footerContact(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}