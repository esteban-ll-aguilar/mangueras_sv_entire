import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
  Size get preferredSize => const Size.fromHeight(70);
}

class _ModernNavBarState extends ConsumerState<ModernNavBar> {
  bool _isHoveringLogout = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 900;
    final authState = ref.watch(authProvider);
    final isAdmin =
        authState is AuthStateAuthenticated && authState.isAdmin;
    final roleLabel = isAdmin ? 'Administrador' : 'Cliente';
    final subtitle = isAdmin ? 'Panel de Administración' : 'Mi Cuenta';

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? 40 : 20,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo y nombre de la empresa
              _buildLogoSection(isWeb, subtitle),

              // Acciones de usuario
              _buildUserActions(isWeb, roleLabel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection(bool isWeb, String subtitle) {
    return Row(
      children: [
        // Logo
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            clipBehavior: Clip.none,
            child: OverflowBox(
              maxWidth: 60,
              maxHeight: 60,
              child: Image.asset(
                widget.logoPath,
                fit: BoxFit.contain,
              ),
            )
          ),
        ),
        if (isWeb) ...[
          const SizedBox(width: 16),
          // Nombre de la empresa
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Mangueras SV',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildUserActions(bool isWeb, String roleLabel) {
    return Row(
      children: [
        // Información del usuario (solo web)
        if (isWeb) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_circle_outlined,
                  size: 20,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  roleLabel,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],

        // Botón de cerrar sesión
        MouseRegion(
          onEnter: (_) => setState(() => _isHoveringLogout = true),
          onExit: (_) => setState(() => _isHoveringLogout = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: InkWell(
              onTap: () {
                _showLogoutConfirmation(context);
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? 16 : 12,
                  vertical: isWeb ? 12 : 10,
                ),
                decoration: BoxDecoration(
                  color: _isHoveringLogout
                      ? Colors.black
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isHoveringLogout
                        ? Colors.black
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      size: isWeb ? 20 : 18,
                      color: _isHoveringLogout ? Colors.white : Colors.black87,
                    ),
                    if (isWeb) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Cerrar Sesión',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _isHoveringLogout
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.logout_outlined,
                  color: Colors.black87,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Cerrar Sesión',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            '¿Estás seguro de que deseas cerrar sesión?',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(authProvider.notifier).signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cerrar Sesión',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
