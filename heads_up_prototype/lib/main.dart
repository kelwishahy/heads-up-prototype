import 'package:flutter/material.dart';
import 'package:heads_up_prototype/pages/home_page.dart';

/// Everything is a widget in flutter, and we compose widgets to create the app
void main() {
  runApp(const MyApp());
}

// Main widget
class MyApp extends StatelessWidget {
  const MyApp(
      {super.key}); // Keys used to track state of widgets when they move around in the widget subtree. Not needed in stateless widgets.

  // builds a widget containing other widgets
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Heads Up',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xff2652cd),
          elevation: 0,
          titleTextStyle: TextStyle(
              fontFamily: 'Arial',
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xff2652cd)),
        ),
      ),
      home: const HomePage(),
    );
  }
}
