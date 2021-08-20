import 'package:flutter/material.dart';
import 'tutorialPage.dart';
import 'designPractice.dart';

void main() => runApp(Nav2App());

class Nav2App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'practice project',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/details': (context) => DetailScreen(),
        '/design': (context) => DesignScreen(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget navigateDesignButton = Container(
      child: TextButton(
        child: Text('design page'),
        onPressed: () {
          Navigator.pushNamed(context, '/design');
        },
      )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('navigation'),
      ),
      body: Column(children: [
        navigateDesignButton,
      ],)
    );
  }
}
