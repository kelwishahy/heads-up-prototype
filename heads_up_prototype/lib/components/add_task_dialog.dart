import "package:flutter/material.dart";
import 'package:heads_up_prototype/components/button.dart';

class AddTaskDialog extends StatelessWidget {
  final taskNameController;
  final hoursToCompleteController;
  DateTime? dueDate;
  VoidCallback onSave;
  VoidCallback onCancel;
  final Function setDate;
  AddTaskDialog(
      {super.key,
      required this.taskNameController,
      required this.hoursToCompleteController,
      required this.onSave,
      required this.onCancel,
      required this.setDate});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 300,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          // get user input
          TextField(
              controller: taskNameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "What's the task?")),

          TextField(
              controller: hoursToCompleteController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "How many hours will it take?")),

          Container(
            alignment: Alignment.centerLeft,
            child: Button(
              buttonText: 'When is it due?',
              onPressed: () async {
                dueDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2024));

                setDate(dueDate);
              },
              colour: const Color(0xff2652cd),
            ),
          ),

          //buttons
          Container(
            alignment: Alignment.bottomRight,
            child: Button(
              buttonText: 'Cancel',
              onPressed: onCancel,
              colour: Colors.red,
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Button(
              buttonText: 'Give me a heads up!',
              onPressed: onSave,
              colour: Colors.green,
            ),
          ),
        ]),
      ),
    );
  }
}
