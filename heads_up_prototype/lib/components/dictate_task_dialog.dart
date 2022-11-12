import 'package:flutter/material.dart';

class DictateDialog extends StatelessWidget {
  const DictateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 300,
      ),
    );
  }
}
