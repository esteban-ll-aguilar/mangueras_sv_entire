import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/brand_model.dart';
import 'dart:async';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/category_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/infrastructure/providers/inventory_providers.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/widgets/shop_welcome_page/shop_welcome_components_widgets.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/widgets/shop_welcome_page/shop_welcome_page_widgets.dart';
import 'package:mangueras_sv_entire/core/core.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopWelcomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ShopWelcomePage> createState() => _ShopWelcomePageState();
}

class _ShopWelcomePageState extends ConsumerState<ShopWelcomePage> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _brandScrollController = ScrollController();
  Timer? _brandScrollTimer;
  bool _showSearchBar = false;

  // Variables para almacenar datos cargados
  List<CategoryModel>? _categories;
  List<BrandModel>? _brands;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _startBrandCarousel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadInitialData(); // Cargar datos después de que el contexto esté listo
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

  Future<void> _loadInitialData() async {
    // Cargar categorías y marcas solo una vez
    _categories = await _getMainCategories();
    _brands = await _getAllBrands();
    setState(() {}); // Actualizar la UI después de cargar los datos
  }

  Future<List<CategoryModel>> _getMainCategories() async {
    if (_categories != null) return _categories!;
    final inventoryProvider = ref.watch(inventoryBrandCategoryRepositoryProvider);
    return inventoryProvider.getMainCategories();
  }

  Future<List<BrandModel>> _getAllBrands() async {
    if (_brands != null) return _brands!;
    final inventoryProvider = ref.watch(inventoryBrandCategoryRepositoryProvider);
    return inventoryProvider.getAllBrands();
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
                child: ShopWelcomeComponentsWidgets.buildHeroSection(
                  context,
                  isMobile,
                  isTablet,
                ),
              ),

              // Stats Section
              SliverToBoxAdapter(
                child: ShopWelcomeComponentsWidgets.buildStatsSection(isMobile),
              ),

              // Categories Section
              SliverToBoxAdapter(
                child: _buildCategoriesSection(context, isMobile, isTablet),
              ),

              // Brands Carousel
              SliverToBoxAdapter(child: _buildBrandsCarousel(isMobile)),

              // Services Section
              SliverToBoxAdapter(
                child: ShopWelcomeComponentsWidgets.buildServicesSection(
                  isMobile,
                  isTablet,
                  context,
                ),
              ),

              // CTA Section
              SliverToBoxAdapter(
                child: ShopWelcomeComponentsWidgets.buildCTASection(isMobile),
              ),

              // Footer
              SliverToBoxAdapter(
                child: ShopWelcomeComponentsWidgets.buildFooter(isMobile),
              ),
            ],
          ),

          // Floating App Bar
          _buildFloatingAppBar(context, isMobile),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          launchUrl(whatsappUri);
        },
        heroTag: 'whatsapp_fab',
        tooltip: 'Contáctanos por WhatsApp',
        backgroundColor: Color(0xFF1A237E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
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
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 48,
            vertical: 16,
          ),
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
              Image.asset('assets/logo.png', height: 80),
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
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Iniciar sesión',
                      icon: const Icon(Icons.person_outline,
                          color: Color(0xFF1A237E)),
                      onPressed: () => context.go('/login'),
                    ),
                    IconButton(
                      tooltip: 'Registrarse',
                      icon: const Icon(Icons.person_add_outlined,
                          color: Color(0xFF1A237E)),
                      onPressed: () => context.go('/signup'),
                    ),
                    SizedBox(width: 4),
                    ElevatedButton(
                      onPressed: () => context.go('/shop/cart'),
                      child: Icon(Icons.shopping_cart, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A237E),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(
    BuildContext context,
    bool isMobile,
    bool isTablet,
  ) {
    if (_categories == null) {
      return Center(child: CircularProgressIndicator());
    }

    return _buildCategoryGrid(_categories!, isMobile, isTablet);
  }

  Widget _buildCategoryGrid(
    List<CategoryModel> categories,
    bool isMobile,
    bool isTablet,
  ) {
    final crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 3);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 24 : 48,
      ),
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
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
              return ShopWelcomePageWidgets.categoryCard(
                category,
                Colors.primaries[index % Colors.primaries.length],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBrandsCarousel(bool isMobile) {
    if (_brands == null) {
      return Center(child: CircularProgressIndicator());
    }

    return ShopWelcomePageWidgets.brandsCarouselContent(
      isMobile,
      _brands!,
      _brandScrollController,
    );
  }
}
