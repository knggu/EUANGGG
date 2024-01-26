import 'package:flutter/material.dart';
import 'home.dart';
import 'colic.dart';
import 'hungry.dart';
import 'inconvenience.dart';
import 'tired.dart';
import 'analyzed.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home.dart',
      routes: {
        '/home.dart': (context) => home(),
        '/colic.dart': (context) => colic(),
        '/hungry.dart': (context) => hungry(),
        '/inconvenience.dart': (context) => inconvenience(),
        '/tired.dart': (context) => tired(),
        '/analyzed.dart': (context) => analyzed()
      },
    );
  }
}
