import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/app/modules/auth/infrastructure/providers/authProvider.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/widgets/auth_reusable_widgets.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/widgets/bezierContainer.dart';
import 'package:mangueras_sv_entire/core/routes/admin_routes.dart';
import 'package:mangueras_sv_entire/core/routes/common_router.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  bool _isLoading = false; // Variable para controlar el estado de carga

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, ingresa tu correo electrónico")),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Activar el estado de carga
    });

    try {
      // Aquí la lógica para autenticar al usuario
      await ref.read(authProvider.notifier).sendResetPasswordEmail(email);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Revisa tu correo electrónico para el enlace de restablecimiento")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Desactivar el estado de carga
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    // Escuchar cambios en el estado de autenticación
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthStateAuthenticated) {
        // Redirigir al HomePage
        context.goNamed(AdminAppRouterNames.home.name);
      } else if (next is AuthStateError) {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            // BezierContainer en la parte superior
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer(),
            ),

            // Contenido principal
            SafeArea(
              child: Column(
                children: [
                  // AppBar custom
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: AuthReusableWidgets.backButton(
                        context,
                        routeName: AdminAppRouterNames.welcome.name,
                      ),
                    ),
                  ),

                  // Contenido scrolleable
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * .08),

                          // Título
                          AuthReusableWidgets.title(
                            titleText: "Recuperar Contraseña",
                            subtitleText: "Ingresa tu correo electrónico para restablecer tu contraseña",
                          ),

                          const SizedBox(height: 40),

                          // Campos de entrada
                          AuthReusableWidgets.inputField(
                            label: "Correo Electrónico",
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),


                         

                          const SizedBox(height: 40),

                          // Botón de login con estado de carga
                          AuthReusableWidgets.primaryButton(
                            text: _isLoading ? 'Recuperando contraseña...' : 'Recuperar Contraseña',
                            onTap: _isLoading ? null : _handleForgotPassword,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
