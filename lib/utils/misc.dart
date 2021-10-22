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