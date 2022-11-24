import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String taskName;
  final double due;
  final double hoursToComplete;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(taskName,
                style: const TextStyle(color: Color(0xff2652cd), fontSize: 24)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    "${hoursToComplete.toStringAsFixed(2)} minutes to complete",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 32, 119, 218),
                        fontSize: 15)),
                const SizedBox(height: 3),
                Text('Minutes until due: ${due.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 210, 89, 89), fontSize: 15)),
                const SizedBox(height: 3),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Swipe to delete",
                style: TextStyle(fontSize: 8, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
