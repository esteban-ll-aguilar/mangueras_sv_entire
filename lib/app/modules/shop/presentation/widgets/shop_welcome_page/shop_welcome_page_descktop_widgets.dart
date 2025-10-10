

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopWelcomePageDescktopWidgets {
  static Widget heroContentDesktop(bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Envíos a todo el país \uD83C\uDDEA\uD83C\uDDE8',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Repuestos de Calidad\nPara Todo Tipo\nde Vehículos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 42 : 56,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 24),
              Text(
                // 'Más de 10,000 productos en stock. Distribución\nautorizada de las mejores marcas del mercado.',
                'Múltiples productos disponibles para ti. Distribución\nautorizada de las mejores marcas del mercado.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  height: 1.6,
                ),
              ),
              SizedBox(height: 40),
              Container(
                constraints: BoxConstraints(maxWidth: 600),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar por código, marca o categoría...',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Buscar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1A237E),
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isTablet)
          Expanded(
            child: Center(
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.settings,
                      size: 200,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    Positioned(
                      top: 50,
                      right: 50,
                      child: floatingIcon(Icons.speed),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 50,
                      child: floatingIcon(Icons.build),
                    ),
                    Positioned(
                      top: 150,
                      left: 30,
                      child: floatingIcon(Icons.electric_bolt),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  static Widget floatingIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: Icon(icon, color: Color(0xFF1A237E), size: 24),
    );
  }
}