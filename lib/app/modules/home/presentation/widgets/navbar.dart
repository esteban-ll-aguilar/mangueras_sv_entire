import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/auth/infrastructure/providers/authProvider.dart';

class ModernNavBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String logoPath;
  final Color backgroundColor;

  const ModernNavBar({
    super.key,
    required this.logoPath,
    required this.backgroundColor,
  });

  @override
  ConsumerState<ModernNavBar> createState() => _ModernNavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _ModernNavBarState extends ConsumerState<ModernNavBar>
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

  // void _toggleNotificationPanel() {
  //   if (_showNotificationPanel) {
  //     setState(() {
  //       _showNotificationPanel = false;
  //     });
  //   } else {
  //     _showNotificationOverlay();
  //   }
  // }

  // void _showNotificationOverlay() {
  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierLabel: 'Notification Panel',
  //     barrierColor: Colors.black.withOpacity(0.3),
  //     transitionDuration: const Duration(milliseconds: 300),
  //     pageBuilder: (context, animation, secondaryAnimation) {
  //       return Align(
  //         alignment: Alignment.topCenter,
  //         child: Container(
  //           margin: EdgeInsets.only(
  //             top: MediaQuery.of(context).padding.top + 56,
  //             left: 16,
  //             right: 16,
  //           ),
  //           child: Material(color: Colors.transparent, child: Container()),
  //         ),
  //       );
  //     },
  //     transitionBuilder: (context, animation, secondaryAnimation, child) {
  //       return SlideTransition(
  //         position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
  //             .animate(
  //               CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
  //             ),
  //         child: FadeTransition(opacity: animation, child: child),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final unreadCount = 10; //TODO: Cambiar por unreadCount > 0
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
                  TextButton.icon(
                    onPressed: (){
                      ref.read(authProvider.notifier).signOut();
                    },
                    icon: const Icon(Icons.logout, size: 28),
                    label: const Text('Cerrar sesión'),
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
