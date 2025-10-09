import 'package:flutter/material.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/brand_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/domain/models/category_model.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/shop/widgets/shop_welcome_page/shop_welcome_page_descktop_widgets.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/shop/widgets/shop_welcome_page/shop_welcome_page_movil_widgets.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';

class ShopWelcomePageWidgets {
  static Widget navButton({required String text, VoidCallback? onPressed}) {
    return TextButton(
      onPressed: onPressed ?? () {},
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  static Widget serviceCard(IconData icon, String title, String description) {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Color(0xFF1A237E)),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static Widget categoryCard(CategoryModel category, Color color) {
    final hasImage = category.imageUrl != null && category.imageUrl!.isNotEmpty;
    // final hasDescription =
    //     category.description != null && category.description!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            //TODO: Aquí puedes navegar a otra vista o hacer algo con category.id
            logging.i('Categoría seleccionada: ${category.name}');
          },
          // borderRadius: BorderRadius.circular(24),
          splashColor: color.withOpacity(0.1),
          highlightColor: color.withOpacity(0.05),
          child: Column(
            children: [
              // Sección superior con imagen de fondo
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.08),
                        color.withOpacity(0.03),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Imagen de la categoría o patrón de puntos
                      if (hasImage)
                        SizedBox.expand(
                          child: Image.network(
                            category.imageUrl!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.fitHeight,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                            (progress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return buildIconFallback(color);
                            },
                          ),
                        ),
                      if (!hasImage)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: DotPatternPainter(color: color),
                          ),
                        ),

                      // Ícono centrado (solo si no hay imagen)
                      if (!hasImage) Center(child: buildIconFallback(color)),
                    ],
                  ),
                ),
              ),

              // Sección inferior con texto
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // if (hasDescription) ...[
                      //   SizedBox(height: 6),
                      //   Text(
                      //     category.description!,
                      //     style: TextStyle(
                      //       fontSize: 11,
                      //       color: Colors.grey[600],
                      //       height: 1.4,
                      //     ),
                      //     textAlign: TextAlign.center,
                      //     maxLines: 2,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildIconFallback(Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.08), color.withOpacity(0.03)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 48,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  static Widget brandsCarouselContent(
    bool isMobile,
    List<BrandModel> brandModels,
    ScrollController brandScrollController,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 60),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Marcas Autorizadas',
            style: TextStyle(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
          SizedBox(height: isMobile ? 24 : 40),
          SizedBox(
            height: 140, // Aumentado para acomodar imagen + texto
            child: ListView.builder(
              controller: brandScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: brandModels.length * 100,
              itemBuilder: (context, index) {
                final brand = brandModels[index % brandModels.length];
                final hasImage =
                    brand.imageUrl != null && brand.imageUrl!.isNotEmpty;

                return Container(
                  width: 180,
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Contenedor de imagen/placeholder
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: hasImage
                                ? Colors.grey[50]
                                : Colors.grey[100],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: hasImage
                              ? ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    brand.imageUrl!,
                                    fit: BoxFit.scaleDown,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 40,
                                          color: Colors.grey[400],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.business_rounded,
                                    size: 50,
                                    color: Colors.grey[400],
                                  ),
                                ),
                        ),
                      ),

                      // Nombre de la marca
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          brand.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A237E),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DotPatternPainter extends CustomPainter {
  final Color color;

  DotPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    const spacing = 20.0;
    const dotRadius = 1.5;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
