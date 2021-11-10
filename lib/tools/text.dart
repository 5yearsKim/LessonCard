import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

// custom
import 'package:lessoncard/utils/misc.dart';

class ColorText extends StatefulWidget {
  const ColorText(this.subjectName, this.subjectColor, {Key? key}) : super(key: key);
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
    _color = code2color(widget.subjectColor);
  }

  @override
  Widget build(BuildContext context) {
    return Text('${widget.subjectName}', style: TextStyle(color: _color));
  }
}
