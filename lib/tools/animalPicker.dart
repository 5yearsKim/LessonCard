import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
// custom
import 'package:myapp/utils/stamp.dart';

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
    return Container(
      child: Wrap(
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (String animal in animalDict.keys)
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: tmpAnimal != animal
                      ? null
                      : Border.all(
                          color: Colors.red,
                        )),
              child: IconButton(
                icon: Image.asset(animalDict[animal] ?? ''),
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
