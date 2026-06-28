import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Modelo para items del menú
class NavItem {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final List<NavSubItem>? subItems;

  NavItem({required this.label, this.icon, this.onTap, this.subItems});
}

class NavSubItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  NavSubItem({required this.label, required this.icon, required this.onTap});
}

class ShopNavbar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final String logoPath;
  final Color backgroundColor;
  final VoidCallback onCartPressed;
  final List<NavItem> navItems;
  final int? cartItemCount;

  const ShopNavbar({
    super.key,
    required this.logoPath,
    required this.backgroundColor,
    required this.onCartPressed,
    required this.navItems,
    this.cartItemCount,
  });

  @override
  ConsumerState<ShopNavbar> createState() => _ShopNavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _ShopNavbarState extends ConsumerState<ShopNavbar>
    with SingleTickerProviderStateMixin {
  final GlobalKey _menuKey = GlobalKey();
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;
    final isTablet = size.width >= 768 && size.width < 1024;
    final isMobile = size.width < 768;

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              _buildLogo(),

              // Desktop/Tablet Menu
              if (isDesktop || (isTablet && widget.navItems.length <= 4))
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildDesktopMenu(),
                  ),
                ),

              // Right actions
              Row(
                children: [
                  if (!isMobile && !isTablet) ...[
                    _buildSearchButton(),
                    const SizedBox(width: 8),
                  ],
                  _buildCartButton(),
                  if (isMobile || (isTablet && widget.navItems.length > 4))
                    _buildHamburgerButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Navegar a home
        },
        child: Hero(
          tag: 'app_logo',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  widget.logoPath,
                  fit: BoxFit.cover,
                  height: 75,
                  width: 75,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDesktopMenu() {
    return List.generate(widget.navItems.length, (index) {
      final item = widget.navItems[index];
      final hasSubItems = item.subItems != null && item.subItems!.isNotEmpty;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: hasSubItems
            ? _buildDropdownItem(item, index)
            : _buildSimpleItem(item, index),
      );
    });
  }

  Widget _buildSimpleItem(NavItem item, int index) {
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: item.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isHovered
                ? Colors.black.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: 18,
                  color: isHovered ? Colors.black : Colors.black87,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isHovered ? FontWeight.w600 : FontWeight.w500,
                  color: isHovered ? Colors.black : Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(NavItem item, int index) {
    final isHovered = _hoveredIndex == index;

    return PopupMenuButton<NavSubItem>(
      key: index == 0 ? _menuKey : null,
      offset: const Offset(0, 8),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (subItem) => subItem.onTap(),
      itemBuilder: (context) {
        return item.subItems!.map((subItem) {
          return PopupMenuItem<NavSubItem>(
            value: subItem,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(subItem.icon, size: 20, color: Colors.black87),
                  const SizedBox(width: 12),
                  Text(
                    subItem.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredIndex = index),
        onExit: (_) => setState(() => _hoveredIndex = null),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isHovered
                ? Colors.black.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: 18,
                  color: isHovered ? Colors.black : Colors.black87,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isHovered ? FontWeight.w600 : FontWeight.w500,
                  color: isHovered ? Colors.black : Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: isHovered ? Colors.black : Colors.black87,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return IconButton(
      onPressed: () {
        // Abrir búsqueda
      },
      icon: const Icon(Icons.search_rounded),
      iconSize: 24,
      color: Colors.black87,
      tooltip: 'Buscar',
    );
  }

  Widget _buildCartButton() {
    final hasItems = widget.cartItemCount != null && widget.cartItemCount! > 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: widget.onCartPressed,
            icon: const Icon(Icons.shopping_bag_outlined),
            iconSize: 24,
            color: Colors.black87,
            tooltip: 'Carrito',
          ),
        ),
        if (hasItems)
          Positioned(
            right: 0,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                widget.cartItemCount! > 99
                    ? '99+'
                    : widget.cartItemCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHamburgerButton() {
    return IconButton(
      onPressed: () => _showMobileMenu(),
      icon: const Icon(Icons.menu_rounded),
      iconSize: 28,
      color: Colors.black87,
      tooltip: 'Menú',
    );
  }

  void _showMobileMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MobileMenu(
        navItems: widget.navItems,
        backgroundColor: widget.backgroundColor,
      ),
    );
  }
}

class _MobileMenu extends StatefulWidget {
  final List<NavItem> navItems;
  final Color backgroundColor;

  const _MobileMenu({required this.navItems, required this.backgroundColor});

  @override
  State<_MobileMenu> createState() => _MobileMenuState();
}

class _MobileMenuState extends State<_MobileMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 100),
          child: Opacity(opacity: _animation.value, child: child),
        );
      },
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Menu items
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                itemCount: widget.navItems.length,
                itemBuilder: (context, index) {
                  final item = widget.navItems[index];
                  final hasSubItems =
                      item.subItems != null && item.subItems!.isNotEmpty;

                  return _buildMobileMenuItem(item, index, hasSubItems);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileMenuItem(NavItem item, int index, bool hasSubItems) {
    final isExpanded = _expandedIndex == index;

    return Column(
      children: [
        InkWell(
          onTap: () {
            if (hasSubItems) {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            } else {
              Navigator.pop(context);
              item.onTap?.call();
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isExpanded
                  ? Colors.black.withOpacity(0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(item.icon, size: 22, color: Colors.black87),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (hasSubItems)
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Subitems expandibles
        if (hasSubItems)
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Container(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Column(
                      children: item.subItems!.map((subItem) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            subItem.onTap();
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  subItem.icon,
                                  size: 18,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  subItem.label,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        const SizedBox(height: 4),
      ],
    );
  }
}

// Ejemplo de uso:
/*
ShopNavbar(
  logoPath: 'assets/logo.png',
  backgroundColor: Colors.white,
  cartItemCount: 3,
  onCartPressed: () {
    // Ir al carrito
  },
  navItems: [
    NavItem(
      label: 'Inicio',
      icon: Icons.home_outlined,
      onTap: () {
        // Navegar a inicio
      },
    ),
    NavItem(
      label: 'Productos',
      icon: Icons.shopping_bag_outlined,
      subItems: [
        NavSubItem(
          label: 'Todos',
          icon: Icons.grid_view_rounded,
          onTap: () {},
        ),
        NavSubItem(
          label: 'Nuevos',
          icon: Icons.new_releases_outlined,
          onTap: () {},
        ),
        NavSubItem(
          label: 'Ofertas',
          icon: Icons.local_offer_outlined,
          onTap: () {},
        ),
      ],
    ),
    NavItem(
      label: 'Categorías',
      icon: Icons.category_outlined,
      subItems: [
        NavSubItem(
          label: 'Electrónica',
          icon: Icons.devices_outlined,
          onTap: () {},
        ),
        NavSubItem(
          label: 'Ropa',
          icon: Icons.checkroom_outlined,
          onTap: () {},
        ),
        NavSubItem(
          label: 'Hogar',
          icon: Icons.home_work_outlined,
          onTap: () {},
        ),
      ],
    ),
    NavItem(
      label: 'Sobre Nosotros',
      icon: Icons.info_outline,
      onTap: () {},
    ),
    NavItem(
      label: 'Contacto',
      icon: Icons.mail_outline,
      onTap: () {},
    ),
  ],
)
*/
