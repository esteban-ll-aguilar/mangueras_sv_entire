import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/app/modules/auth/infrastructure/providers/authProvider.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/widgets/bezierContainer.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/widgets/auth_reusable_widgets.dart';
import 'package:mangueras_sv_entire/core/routes/router.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = true;
  bool _isLoading = false;

  Future<void> _handleRegistration() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa tanto el correo electrónico como la contraseña')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Activar el estado de carga
    });

    try {
      // Lógica para registrar al usuario
      await ref.read(authProvider.notifier).signUp(email, password);
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
        // Redirigir al HomePage si el registro es exitoso
        context.goNamed(AppRouterNames.home.name);
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
                        routeName: AppRouterNames.welcome.name,
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
                            titleText: "Crear Cuenta",
                            subtitleText: "Únete a VitaGest hoy mismo",
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
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passwordController,
                            isPassword: true,
                            obscureText: !_isPasswordVisible,
                            onSuffixIconTap: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),

                          const SizedBox(height: 32),

                          // Botón de registro
                          AuthReusableWidgets.primaryButton(
                            text: _isLoading
                                ? 'Creando cuenta...'
                                : 'Crear Cuenta',
                            onTap: _isLoading ? null : _handleRegistration,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                : null,
                          ),

                          // const SizedBox(height: 24),
                          // // Divider
                          // AuthReusableWidgets.divider(),
                          // const SizedBox(height: 24),
                          // AuthReusableWidgets.googleButton(
                          //   title: context.translatorL10.signUpWithGoogleText,
                          //   onPressed: () {
                          //     // TODO: Implementar registro con Google
                          //   },
                          // ),
                          const SizedBox(height: 40),

                          // Footer
                          AuthReusableWidgets.footer(
                            callToAction: "¿Ya tienes una cuenta?",
                            actionText: "Iniciar Sesión",
                            onTap: () =>
                                context.goNamed(AppRouterNames.login.name),
                          ),

                          const SizedBox(height: 24),
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
