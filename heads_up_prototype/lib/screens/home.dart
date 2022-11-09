import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      appBar: AppBar(
        title: const Text(
          'Heads Up',
          // style: TextStyle(color: Color(0x002652cd)),
        ),
        elevation: 0,
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        // foregroundColor: const Color.fromARGB(0, 38, 82, 205)
      ),
      body: Container(
        child: const Text('Home screen'),
      ),
    );
  }
}
