import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
// custom
import 'package:lessonCard/utils/stamp.dart';
import 'package:lessonCard/config.dart';

class AnimalPicker extends StatefulWidget {
  final String animal;
  final Function onChangeAnimal;
  AnimalPicker({String this.animal = '', required Function this.onChangeAnimal, Key? key}) : super(key: key);

  @override
  _AnimalPickerState createState() => _AnimalPickerState();
}

class _AnimalPickerState extends State<AnimalPicker> {
  String tmpAnimal = '';

  @override
  void initState() {
    super.initState();
    tmpAnimal = widget.animal;
  }

  @override
  Widget build(BuildContext context) {
    int tmpSize = MediaQuery.of(context).orientation == Orientation.portrait ? STAMP_SIZE_SMALL : STAMP_SIZE_LARGE;
    double stampSize = tmpSize * 1.2;
    print(stampSize);
    return Container(
      child: Wrap(
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (String animal in animalDict.keys)
            Container(
              padding: EdgeInsets.all(3),
              width: stampSize + 1.0,
              height: stampSize + 1.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: tmpAnimal != animal
                    ? null
                    : Border.all(
                        color: Colors.red,
                        width: 2,
                      ),
              ),
              child: IconButton(
                icon: Image.asset(
                  animalDict[animal] ?? '',
                  width: stampSize - 3,
                  height: stampSize - 3,
                ),
                onPressed: () {
                  setState(() {
                    tmpAnimal = animal;
                  });
                  widget.onChangeAnimal(animal);
                },
              ),
            )
        ],
      ),
    );
  }
}
