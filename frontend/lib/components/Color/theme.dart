import 'package:flutter/material.dart';

// const color for background theme, navbar and others
class Theme {
  // Background
  static const Color mainBackground = Color.fromRGBO(252, 252, 252, 1);

  // navbar
  static const Color navbarBackground = Color.fromRGBO(252, 252, 252, 1);
  static const Color navbarText = Color.fromRGBO(179, 179, 179, 1);
  static const Color navbarFocusText = Color.fromRGBO(18, 53, 143, 1);

  // button (* include gradient button *)
  static const Color buttonBackground = Color.fromRGBO(18, 53, 143, 1);

  static const buttonNearChartBackground = LinearGradient(
    colors: [
      Color(0xFF12358F),
      Color(0xFFF5BBD1)
    ],
    stops: [0.4, 1.0],
  );

  static const buttonScanBackground = LinearGradient(
    colors: [
      Color(0xFF12358F),
      Color(0xFF749DF5)
    ],
    stops: [0.4, 1.0],
  );

  static const Color buttonBorder = Color.fromRGBO(0, 0, 0, 1);

  // text
  static const Color mainText = Color.fromRGBO(0, 0, 0, 1);
  static const Color hyperlinkedText = Color.fromRGBO(18, 53, 143, 1);
  static const Color buttonText = Color.fromRGBO(255, 255, 255, 1);
  static const Color placeholderText = Color.fromRGBO(179, 179, 179, 1);

  // misc
  // static const Color test = Colors.blue;
  // static const Color test2 = Colors.pink;

}