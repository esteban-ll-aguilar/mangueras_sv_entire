import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangueras_sv_entire/app/modules/auth/infrastructure/providers/authProvider.dart';
import 'package:mangueras_sv_entire/core/routes/admin_routes.dart';
import 'package:mangueras_sv_entire/core/routes/common_router.dart';

class AuthWelcomePage extends ConsumerStatefulWidget {
  const AuthWelcomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<AuthWelcomePage> {
  Widget _primaryButton({
    required String text,
    required VoidCallback onTap,
    bool isPrimary = true,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.black : Colors.transparent,
          foregroundColor: isPrimary ? Colors.white : Colors.black,
          elevation: 0,
          side: isPrimary ? null : const BorderSide(color: Colors.black12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }



  Widget _footer() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          "Todos los derechos reservados",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _logo() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Image.asset('assets/logo.png'),
        ),
        const SizedBox(height: 24),
        Text(
          'VitaGest',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Iniciar Sesión",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthStateAuthenticated) {
        // Redirigir al HomePage si el usuario ya está autenticado
        context.goNamed(AdminAppRouterNames.home.name);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'v0.0.1',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo y título
              _logo(),

              const Spacer(flex: 3),

              // Botones
              Column(
                children: [
                  _primaryButton(
                    text: "Iniciar Sesión",
                    onTap: () => context.goNamed(AdminAppRouterNames.login.name),
                  ),
                  // const SizedBox(height: 16),
                  // _primaryButton(
                  //   text: "Crear Cuenta",
                  //   onTap: () => context.goNamed(AdminAppRouterNames.signup.name),
                  //   isPrimary: false,
                  // ),
                ],
              ),

              // Footer
              _footer(),
            ],
          ),
        ),
      ),
    );
  }
}
