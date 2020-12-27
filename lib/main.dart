import 'package:biller/util/route_generator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biller',
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.blue[700],
        // fontFamily: 'AlegreyaSans'
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}