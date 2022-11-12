import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final String taskName;
  final String due;
  final int hoursToComplete;

  const TaskCard(
      {super.key,
      required this.taskName,
      required this.due,
      required this.hoursToComplete});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 242, 238, 238),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(taskName,
                style: const TextStyle(color: Color(0xff2652cd), fontSize: 24)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Due: $due',
                    style: const TextStyle(
                        color: Color(0xff2652cd), fontSize: 15)),
                const SizedBox(width: 8),
                Text("$hoursToComplete hours to complete",
                    style: const TextStyle(
                        color: Color(0xff2652cd), fontSize: 15)),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
