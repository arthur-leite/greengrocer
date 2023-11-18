import "package:flutter/material.dart";

Map<int, Color> _swatchOpacity = {
  50 : const Color.fromRGBO(139, 195, 74, 0.1),
  100 : const Color.fromRGBO(139, 195, 74, 0.2),
  200 : const Color.fromRGBO(139, 195, 74, 0.3),
  300 : const Color.fromRGBO(139, 195, 74, 0.4),
  400 : const Color.fromRGBO(139, 195, 74, 0.5),
  500 : const Color.fromRGBO(139, 195, 74, 0.6),
  600 : const Color.fromRGBO(139, 195, 74, 0.7),
  700 : const Color.fromRGBO(139, 195, 74, 0.8),
  800 : const Color.fromRGBO(139, 195, 74, 0.9),
  900 : const Color.fromRGBO(139, 195, 74, 1.0)
};

// Map<int, Color> _swatchOpacity = {
//      50: Color(0xFFFFF3E0),
//     100: Color(0xFFFFE0B2),
//     200: Color(0xFFFFCC80),
//     300: Color(0xFFFFB74D),
//     400: Color(0xFFFFA726),
//     600: Color(0xFFFB8C00),
//     700: Color(0xFFF57C00),
//     800: Color(0xFFEF6C00),
//     900: Color(0xFFE65100),
// };

abstract class CustomColors {
  
  static Color customContrastColor = const Color.fromARGB(255, 138, 29, 29);

  static MaterialColor customSwatchColor = MaterialColor(0xFF8BC34A, _swatchOpacity);
  //static MaterialColor customSwatchColor = MaterialColor(0xFFE65100, _swatchOpacity);
}