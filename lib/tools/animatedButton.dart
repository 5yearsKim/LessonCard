
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final bool clicked;
  final VoidCallback onPressed;
  final String label;
  AnimatedButton({this.clicked: false, required this.onPressed, required this.label}) {
  }

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  get _color {
    return widget.clicked ? Colors.amber : Colors.black.withOpacity(0.1);
  }
  get _padding {
    return widget.clicked ? 20.0 : 10.0;
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onPressed();
      },
      child: AnimatedContainer(
        padding: EdgeInsets.all(_padding),
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.all(Radius.elliptical(50, 50)),
        ),
        duration: Duration(milliseconds: 300),
        child: Text(widget.label),
      ),
    );
  }
}