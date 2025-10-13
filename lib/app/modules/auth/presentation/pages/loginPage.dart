import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/app/modules/auth/infrastructure/providers/authProvider.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/widgets/auth_reusable_widgets.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/widgets/bezierContainer.dart';
import 'package:mangueras_sv_entire/core/routes/admin_routes.dart';
import 'package:mangueras_sv_entire/core/routes/common_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = true;
  bool _isLoading = false; // Variable para controlar el estado de carga

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, ingresa tanto el correo electrónico como la contraseña")),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Activar el estado de carga
    });

    try {
      // Aquí la lógica para autenticar al usuario
      await ref.read(authProvider.notifier).signIn(email, password);
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
                            titleText: "Inicia Sesión",
                            subtitleText: "Bienvenido de nuevo, te hemos extrañado",
                          ),

                          const SizedBox(height: 40),

                          // Campos de entrada
                          AuthReusableWidgets.inputField(
                            label: "Correo Electrónico",
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 20),

                          AuthReusableWidgets.inputField(
                            label: "Contraseña",
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            obscureText: !_isPasswordVisible,
                            onSuffixIconTap: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),

                          const SizedBox(height: 12),

                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                context.goNamed(AdminAppRouterNames.forgotPassword.name);
                              },
                              child: Text(
                                "¿Olvidaste tu contraseña?",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Botón de login con estado de carga
                          AuthReusableWidgets.primaryButton(
                            text: _isLoading ? 'Iniciando sesión...' : 'Iniciar Sesión',
                            onTap: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                : null,
                          ),

                          // const SizedBox(height: 24),
                          // Divider
                          // ReusableWidgets.divider(),
                          // const SizedBox(height: 24),
                          // // Google button
                          // ReusableWidgets.googleButton(
                          //   title: context.translatorL10.continueWithGoogleText,
                          //   onPressed: () {
                          //     // TODO: Implementar login con Google
                          //   },
                          // ),
                          const SizedBox(height: 40),

                          // // Footer
                          // ReusableWidgets.footer(
                          //   callToAction: "¿No tienes una cuenta?",
                          //   actionText: "Regístrate",
                          //   onTap: () =>
                          //       context.goNamed(AppRouterNames.signup.name),
                          // ),

                          // const SizedBox(height: 24),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
