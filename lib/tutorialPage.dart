import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TutorialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Column _buildButtonColumn(Color color, IconData icon, String label) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }


    Color color = Theme.of(context).primaryColor;
    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(color, Icons.call, 'CALL'),
        _buildButtonColumn(color, Icons.near_me, 'NEAR'),
        _buildButtonColumn(color, Icons.share, 'SHARE'),
      ],
    );
    return MaterialApp(
      title: 'flutter layout',
      home: Scaffold(
        appBar: AppBar(
          title: Text('flutter layout holyyyyy'),
        ),
        body: Column(children: [
          Image.asset(
            'images/sample.png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          titleSection(),
          buttonSection,
          customButton(context),
        ]), 
      )
    );
  }
}

Widget customButton(context) => Container(
  padding: EdgeInsets.all(10),
  child: TextButton(
    child: Text('Click here'),
    onPressed: () {
      Navigator.pushNamed(
        context,
        '/details',
      );
    }
  )
); 

Widget titleSection() => Container(
  padding: EdgeInsets.all(32),
  child: Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'readability oo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )
              )
            ),
            Text(
              'kukuku kukuk',
              style: TextStyle(
                color: Colors.grey[500],
              )
            ),
          ]
        ),
      ),
      FavoriteWidget(),
    ],
  ),
);

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          child: Text('Pop!'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({Key? key}) : super(key: key);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;
  @override
  Widget build(BuildContext context) {
    void _toggleFavorite() {
      setState(() {
        if (_isFavorited) {
          _favoriteCount -= 1;
          _isFavorited = false;
        } else {
          _favoriteCount += 1;
          _isFavorited = true;
        }
      });
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            padding: EdgeInsets.all(0),
            alignment: Alignment.centerRight,
            icon: (_isFavorited
                ? Icon(Icons.star)
                : Icon(Icons.star_border)),
            color: Colors.red[500],
            onPressed: _toggleFavorite,
          ),
        ),
        SizedBox(
          width: 18,
          child: SizedBox(
            child: Text('$_favoriteCount'),
          ),
        ),
      ],
    );
  }
}