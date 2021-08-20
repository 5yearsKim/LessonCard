import 'package:flutter/material.dart';

class SampleImage {
  const SampleImage(this.name, this.imageUrl);
  final String name;
  final String imageUrl;
}

final List<SampleImage> sampleImages = [
  SampleImage('random1', 'https://picsum.photos/200/300'),
  SampleImage('random2', 'https://picsum.photos/200'),
];

class DesignScreen extends StatelessWidget {

  Widget _dialogOpen(BuildContext context, SampleImage sampleImage) {
    ThemeData localTheme = Theme.of(context);
    return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      children: [
        Image.network(sampleImage.imageUrl,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(sampleImage.name, style: localTheme.textTheme.headline5),
              Text('hello from earth'),
            ]
          )
        )
      ],
    );
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    return Container(
      child: TextButton(
        child: Text(sampleImages[index].name,
          style: Theme.of(context).textTheme.headline3,
        ),
        onPressed: () => showDialog(context: context, builder: (context) => _dialogOpen(context, sampleImages[index])),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('design page'),
      ),
      body: ListView.builder(
        itemCount: sampleImages.length,
        itemBuilder: _listItemBuilder,

      ),
    );
  }
}