import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class ButtonNavigatorBar extends StatelessWidget {
  final List<IconData> iconsList; // Lista dinámica de íconos
  final ValueChanged<int> onTap; // Callback para manejar taps
  final Color backgroundColor;
  final Color color;
  final Color buttonBackgroundColor;
  final Color iconColor;
  final Duration animationDuration;
  final int initialIndex;

  const ButtonNavigatorBar({
    super.key,
    required this.iconsList,
    required this.onTap, // Callback predeterminado
    this.backgroundColor = Colors.transparent,
    this.color = Colors.black,
    this.buttonBackgroundColor = Colors.black,
    this.iconColor = Colors.white,
    this.animationDuration = const Duration(milliseconds: 300),
    this.initialIndex = 0,

  });


  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: backgroundColor,
      color: color,
      index: initialIndex,
      animationDuration: animationDuration,
      buttonBackgroundColor: buttonBackgroundColor,
      height: 60,
      items: iconsList
          .map((icon) => Icon(icon, size: 30, color: iconColor))
          .toList(), // Generar ítems dinámicamente
      onTap: onTap, // Callback para manejar taps
    );
  }
}