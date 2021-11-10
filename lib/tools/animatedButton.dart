import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

// custom
import 'package:lessoncard/config.dart';

class AnimatedButton extends StatefulWidget {
  final bool clicked;
  final VoidCallback onPressed;
  final String label;
  AnimatedButton({this.clicked: false, required this.onPressed, required this.label}) {}

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  get _color {
    return widget.clicked ? primaryColor : Colors.black.withOpacity(0.1);
  }

  get _textColor {
    return widget.clicked ? Colors.white : Colors.grey[850];
  }

  get _padding {
    return widget.clicked ? 20.0 : 10.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: AnimatedContainer(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(_padding),
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.circular(50),
          boxShadow: !widget.clicked
              ? null
              : [
                  BoxShadow(
                    color: _color.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
        ),
        duration: Duration(milliseconds: 300),
        child: Text(
          widget.label,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: _textColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
