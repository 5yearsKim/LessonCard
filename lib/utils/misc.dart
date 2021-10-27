import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

Color code2color(colorCode, {defaultColor: Colors.blue}) {
  var _color;
  try {
    _color = Color(int.parse(colorCode));
  } catch (e) {
    _color = defaultColor;
  }
  return _color;
}

Color textOnColor(Color color) {
  return color.computeLuminance() >= 0.65 ? Colors.indigo.shade900 : Colors.white;
}

Color lightenColor(Color color, {double amount: 0.1}) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness * (1 + amount)).clamp(0.0, 1.0));

  return hslLight.toColor();
}
