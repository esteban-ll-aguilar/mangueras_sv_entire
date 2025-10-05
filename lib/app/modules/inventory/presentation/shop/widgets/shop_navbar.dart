import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/auth/infrastructure/providers/authProvider.dart';

class ShopNavbar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String logoPath;
  final Color backgroundColor;

  const ShopNavbar({
    super.key,
    required this.logoPath,
    required this.backgroundColor,
  });

  @override
  ConsumerState<ShopNavbar> createState() => _ShopNavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _ShopNavbarState extends ConsumerState<ShopNavbar>
    with SingleTickerProviderStateMixin {
  // bool _showNotificationPanel = false;
  late AnimationController _pulseController;
  // late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    // _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
    //   CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    // );

    // Pulse animation for unread notifications
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBar(
          backgroundColor: widget.backgroundColor,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo a la izquierda con animación
              Hero(
                tag: 'app_logo',
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.logoPath,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Ícono de notificaciones e imagen de perfil a la derecha
              Row(
                children: [
                  

                  IconButton(
                    onPressed: (){
                      //TODO: Shop carrito
                    },
                    icon: const Icon(Icons.shopping_cart, size: 28),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black, // ajustar color según fondo
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
