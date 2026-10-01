import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/app/modules/auth/infrastructure/providers/authProvider.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/widgets/bezierContainer.dart';
import 'package:mangueras_sv_entire/app/modules/auth/presentation/widgets/auth_reusable_widgets.dart';
import 'package:mangueras_sv_entire/core/routes/app_router.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  Future<void> _handleRegistration() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage(
        'Por favor, ingresa tanto el correo electrónico como la contraseña',
      );
      return;
    }

    if (!_isValidEmail(email)) {
      _showMessage('Por favor, ingresa un correo electrónico válido',
          isError: true);
      return;
    }

    if (password.length < 6) {
      _showMessage('La contraseña debe tener al menos 6 caracteres',
          isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(authProvider.notifier).signUp(email, password);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 900;
    final isTablet = size.width > 600 && size.width <= 900;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthStateAuthenticated) {
        context.goNamed(AppRouteNames.home.name);
      } else if (next is AuthStateError) {
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
      body: isWeb ? _buildWebLayout(size) : _buildMobileLayout(size, isTablet),
    );
  }

  // Layout para Web
  Widget _buildWebLayout(Size size) {
    return Row(
      children: [
        // Panel izquierdo con imagen Memphis
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromARGB(255, 9, 50, 112),
                  const Color.fromARGB(255, 35, 8, 67),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Patrón Memphis decorativo
                Positioned.fill(child: CustomPaint(painter: MemphisPainter())),
                // Contenido del panel izquierdo
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo o imagen corporativa
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.none,
                          child: OverflowBox(
                            maxWidth: 175,
                            maxHeight: 175,
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Únete a Mangueras SV',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Comienza a gestionar tu negocio de forma profesional',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _buildFeatureChip('Fácil de Usar'),
                            _buildFeatureChip('Seguro y Confiable'),
                            _buildFeatureChip('Soporte 24/7'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Panel derecho con formulario
        Expanded(
          flex: 4,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: _buildSignupForm(isWeb: true),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Layout para Móvil y Tablet
  Widget _buildMobileLayout(Size size, bool isTablet) {
    return Stack(
      children: [
        // BezierContainer con Memphis pattern
        Positioned(
          top: -size.height * 0.15,
          right: -size.width * 0.4,
          child: Stack(
            children: [
              const BezierContainer(),
              Positioned.fill(
                child: CustomPaint(painter: MemphisPainter(isMobile: true)),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: AuthReusableWidgets.backButton(
                    context,
                    routeName: AppRouteNames.authWelcome.name,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 64 : 24),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.08),
                      // Logo corporativo
                      Container(
                        width: isTablet ? 100 : 80,
                        height: isTablet ? 100 : 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: OverflowBox(
                          maxWidth: isTablet ? 180 : 140,
                          maxHeight: isTablet ? 180 : 140,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildSignupForm(isWeb: false, isTablet: isTablet),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Formulario de registro reutilizable
  Widget _buildSignupForm({bool isWeb = false, bool isTablet = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthReusableWidgets.title(
          titleText: "Crear Cuenta",
          subtitleText: "Únete a Mangueras SV hoy mismo",
        ),
        SizedBox(height: isWeb ? 48 : 32),
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
        SizedBox(height: isWeb ? 48 : 32),
        AuthReusableWidgets.primaryButton(
          text: _isLoading ? 'Creando cuenta...' : 'Crear Cuenta',
          onTap: _isLoading ? null : _handleRegistration,
          isLoading: _isLoading,
        ),
        SizedBox(height: isWeb ? 32 : 24),
        Center(
          child: AuthReusableWidgets.footer(
            callToAction: "¿Ya tienes una cuenta?",
            actionText: "Iniciar Sesión",
            onTap: () => context.goNamed(AppRouteNames.login.name),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
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

// Painter para el patrón Memphis
class MemphisPainter extends CustomPainter {
  final bool isMobile;

  MemphisPainter({this.isMobile = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Colores Memphis
    final colors = [
      Colors.yellow.withOpacity(0.3),
      Colors.cyan.withOpacity(0.3),
      Colors.pink.withOpacity(0.3),
      Colors.white.withOpacity(0.2),
    ];

    // Dibujar círculos
    for (int i = 0; i < 5; i++) {
      paint.color = colors[i % colors.length];
      canvas.drawCircle(
        Offset(size.width * (0.2 + i * 0.15), size.height * (0.3 + i * 0.1)),
        isMobile ? 20 + i * 5 : 40 + i * 10,
        paint,
      );
    }

    // Dibujar zigzags
    final zigzagPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.5);
    for (int i = 0; i < 8; i++) {
      path.lineTo(
        size.width * (0.1 + i * 0.1),
        size.height * (0.5 + (i % 2 == 0 ? 0.05 : -0.05)),
      );
    }
    canvas.drawPath(path, zigzagPaint);

    // Dibujar triángulos
    for (int i = 0; i < 3; i++) {
      final trianglePath = Path();
      final x = size.width * (0.7 + i * 0.1);
      final y = size.height * (0.2 + i * 0.2);
      final triangleSize = isMobile ? 15.0 : 30.0;

      trianglePath.moveTo(x, y - triangleSize);
      trianglePath.lineTo(x - triangleSize, y + triangleSize);
      trianglePath.lineTo(x + triangleSize, y + triangleSize);
      trianglePath.close();

      canvas.drawPath(
        trianglePath,
        Paint()
          ..color = colors[(i + 1) % colors.length]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
