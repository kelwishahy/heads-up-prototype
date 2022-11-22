import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:heads_up_prototype/components/button.dart';

class AddTaskDialog extends StatelessWidget {
  final taskNameController;
  final hoursToCompleteController;
  final timeUntilDueController;
  DateTime? dueDate;
  VoidCallback onSave;
  VoidCallback onCancel;
  final Function setDate;
  AddTaskDialog(
      {super.key,
      required this.taskNameController,
      required this.hoursToCompleteController,
      required this.timeUntilDueController,
      required this.onSave,
      required this.onCancel,
      required this.setDate});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        width: 500,
        height: 350,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          // get user input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "*Required",
                style: TextStyle(fontSize: 8, color: Colors.red),
              ),
              TextField(
                controller: taskNameController,
                maxLines: 1,
                minLines: 1,
                maxLength: 30,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "What's the task?",
                ),
              ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "*Required",
                style: TextStyle(fontSize: 8, color: Colors.red),
              ),
              TextField(
                  controller: timeUntilDueController,
                  maxLength: 2,
                  minLines: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[\.]')),
                    FilteringTextInputFormatter.deny(
                      RegExp(r'^0+(?=.)'),
                    ),
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^[0-9]*$'),
                    ),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "In how many minutes is it due?",
                  )),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "*Required",
                style: TextStyle(fontSize: 8, color: Colors.red),
              ),
              TextField(
                  controller: hoursToCompleteController,
                  maxLength: 2,
                  minLines: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[\.]')),
                    FilteringTextInputFormatter.deny(
                      RegExp(r'^0+(?=.)'),
                    ),
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^[0-9]*$'),
                    ),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "How many minutes will it take to complete?",
                  )),
            ],
          ),

          // Container(
          //   alignment: Alignment.centerLeft,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Button(
          //         buttonText: 'When is it due?',
          //         onPressed: () async {
          //           dueDate = await showDatePicker(
          //               context: context,
          //               initialDate: DateTime.now(),
          //               firstDate: DateTime.now(),
          //               lastDate: DateTime(2024));

          //           setDate(dueDate);
          //           dueDate = DateTime.now();
          //         },
          //         colour: const Color(0xff2652cd),
          //       ),
          //       const Text(
          //         "Defaults to today's date",
          //         style: TextStyle(fontSize: 8),
          //       ),
          //     ],
          //   ),
          // ),

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
