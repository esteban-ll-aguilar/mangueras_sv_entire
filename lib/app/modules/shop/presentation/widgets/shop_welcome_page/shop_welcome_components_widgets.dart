import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/widgets/shop_welcome_page/shop_welcome_page_descktop_widgets.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/widgets/shop_welcome_page/shop_welcome_page_movil_widgets.dart';
import 'package:mangueras_sv_entire/app/modules/shop/presentation/widgets/shop_welcome_page/shop_welcome_page_widgets.dart';
import 'package:mangueras_sv_entire/core/core.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopWelcomeComponentsWidgets {
  static Widget buildStatsSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 24 : 48,
      ),
      child: isMobile
          ? Column(
              children: [
                statItem('10,000+', 'Productos', Icons.inventory_2),
                SizedBox(height: 32),
                statItem('50+', 'Marcas', Icons.verified),
                SizedBox(height: 32),
                statItem('15 años', 'Experiencia', Icons.emoji_events),
                SizedBox(height: 32),
                statItem('24/7', 'Soporte', Icons.support_agent),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                statItem('10,000+', 'Productos', Icons.inventory_2),
                statItem('50+', 'Marcas', Icons.verified),
                statItem('15 años', 'Experiencia', Icons.emoji_events),
                statItem('24/7', 'Soporte', Icons.support_agent),
              ],
            ),
    );
  }

  static Widget statItem(String number, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF1A237E).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFF1A237E), size: 32),
        ),
        SizedBox(height: 16),
        Text(
          number,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
      ],
    );
  }

  static Widget buildServicesSection(
    bool isMobile,
    bool isTablet,
    BuildContext context,
  ) {
    final services = [
      {
        'icon': Icons.local_shipping,
        'title': 'Envío Rápido',
        'description': 'Entregas en 24-48 horas a nivel nacional',
      },
      {
        'icon': Icons.verified_user,
        'title': 'Garantía Total',
        'description': 'Todos nuestros productos certificados',
      },
      {
        'icon': Icons.support_agent,
        'title': 'Asesoría Técnica',
        'description': 'Expertos disponibles para ayudarte',
      },
      {
        'icon': Icons.price_check,
        'title': 'Mejores Precios',
        'description': 'Precios competitivos garantizados',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 24 : 48,
      ),
      child: Column(
        children: [
          Text(
            '¿Por Qué Elegirnos?',
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 32 : 48),
          isMobile
              ? Column(
                  children: services
                      .map(
                        (s) => Padding(
                          padding: EdgeInsets.only(bottom: 24),
                          child: ShopWelcomePageWidgets.serviceCard(
                            s['icon'] as IconData,
                            s['title'] as String,
                            s['description'] as String,
                          ),
                        ),
                      )
                      .toList(),
                )
              : Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: services
                      .map(
                        (s) => SizedBox(
                          width: isTablet
                              ? MediaQuery.of(context).size.width / 2 - 58
                              : MediaQuery.of(context).size.width / 4 - 63,
                          child: ShopWelcomePageWidgets.serviceCard(
                            s['icon'] as IconData,
                            s['title'] as String,
                            s['description'] as String,
                          ),
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }

  static Widget buildHeroSection(
    BuildContext context,
    bool isMobile,
    bool isTablet,
  ) {
    return Container(
      height: isMobile ? 600 : 700,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A237E), Color(0xFF0D47A1), Color(0xFF1565C0)],
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(painter: GridPatternPainter()),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Top Navigation
                Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 32),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: isMobile ? 60 : 70,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Mangueras SV',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 20 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      if (!isMobile) ...[
                        ShopWelcomePageWidgets.navButton(
                          text: 'Productos',
                          onPressed: () {
                            context.go('/shop/products');
                          }
                        ),
                        SizedBox(width: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            // context.go('/shop/products');
                          },
                          icon: Icon(Icons.shopping_cart),
                          label: Text('Ver Carrito'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF1A237E),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ] else
                        IconButton(
                          icon: Icon(Icons.shopping_cart, color: Colors.white),
                          onPressed: () {},
                        ),
                    ],
                  ),
                ),

                // Hero Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 24 : 48,
                    ),
                    child: isMobile
                        ? ShopWelcomePageMovilWidgets.heroContentMobile()
                        : ShopWelcomePageDescktopWidgets.heroContentDesktop(
                            isTablet,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildCTASection(bool isMobile) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: isMobile ? 40 : 80,
      ),
      padding: EdgeInsets.all(isMobile ? 32 : 64),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF1565C0)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            '¿Listo para encontrar tus repuestos?',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 24 : 36,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Contáctanos hoy y recibe asesoría personalizada',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  launchUrl(phoneNumberUri);
                },
                icon: Icon(Icons.phone),
                label: Text('Llamar Ahora'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF1A237E),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  launchUrl(emailUri);
                },
                icon: Icon(Icons.email),
                label: Text('Enviar Email'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white, width: 2),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 32 : 48),
      color: Color(0xFF1A237E),
      child: Column(
        children: [
          if (!isMobile)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/logo.png', height: 45),
                          SizedBox(width: 5),
                          Text(
                            'Mangueras SV',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tu socio confiable en repuestos\nautomotrices desde 2009.',
                        style: TextStyle(color: Colors.white70, height: 1.6),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enlaces Rápidos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      footerLink('Sobre Nosotros'),
                      footerLink('Catálogo'),
                      footerLink('Marcas'),
                      footerLink('Blog'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contacto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      footerContact(Icons.phone, '+593 99 123 4567',
                          onTap: () {
                        launchUrl(phoneNumberUri);
                      }),
                      footerContact(Icons.email, 'info@autopartspro.com',
                          onTap: () {
                        launchUrl(emailUri);
                      }),
                      footerContact(Icons.location_on, 'Guayaquil, Ecuador',
                          onTap: () {
                        launchUrl(locationUri);
                      }),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                Icon(Icons.build_circle, color: Colors.white, size: 40),
                SizedBox(height: 16),
                Text(
                  'Mangueras SV',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                footerContact(
                  Icons.phone,
                  '+593 99 123 4567',
                  onTap: () {
                    launchUrl(phoneNumberUri);
                  },
                ),
                SizedBox(height: 12),
                footerContact(
                  Icons.email,
                  'info@autopartspro.com',
                  onTap: () {
                    launchUrl(emailUri);
                  },
                ),
                footerContact(
                  Icons.location_on,
                  'Piñas, El Oro, Ecuador',
                  onTap: () {
                    launchUrl(locationUri);
                  },
                ),
              ],
            ),
          SizedBox(height: 32),
          Divider(color: Colors.white24),
          SizedBox(height: 24),
          Text(
            '© 2024 AutoParts Pro. Todos los derechos reservados.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static Widget footerLink(String text, {VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Text(text, style: TextStyle(color: Colors.white70)),
      ),
    );
  }

  static Widget footerContact(
    IconData icon,
    String text, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () async {
                if (onTap != null) {
                  onTap();
                }
              },
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
