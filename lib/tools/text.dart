import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class ColorText extends StatefulWidget {
  const ColorText(this.subjectName, this.subjectColor, { Key? key }) : super(key: key);
  final subjectName;
  final subjectColor;

  @override
  _ColorTextState createState() => _ColorTextState();
}

class _ColorTextState extends State<ColorText> {
  Color _color = Colors.blue;

  @override
  void initState() {
    super.initState();
    try {
      _color = Color(int.parse(widget.subjectColor));
    } catch (e) {
      _color = Colors.blue;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Text('${widget.subjectName}',
      style: TextStyle(color: _color)
    );
  }
}