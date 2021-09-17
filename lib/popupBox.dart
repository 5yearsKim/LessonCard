import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class PopupBox extends StatefulWidget {
  final visible;
  final onDismiss;
  final child;
  const PopupBox({
    Key? key,
    @required this.visible,
    @required this.onDismiss,
    this.child,
  }) : super(key: key);

  @override
  _PopupBoxState createState() => _PopupBoxState();
}

class _PopupBoxState extends State<PopupBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => widget.onDismiss());
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }
}
