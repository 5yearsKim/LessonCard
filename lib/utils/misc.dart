import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'dart:math';
// custom
import 'package:lessoncard/config.dart';

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
  return color.computeLuminance() >= 0.65 ? textColor : Colors.white;
}

Color lightenColor(Color color, {double amount: 0.3}) {
  double lighter(num x, num amount) {
    amount = amount.clamp(1, 5);
    num newLight = 1 - pow(1 - x, amount);
    return newLight.toDouble();
  }

  final hsl = HSLColor.fromColor(color);
  double newLightness = lighter(hsl.lightness, 1 + amount);
  final hslLight = hsl.withLightness(newLightness);

  return hslLight.toColor();
}
