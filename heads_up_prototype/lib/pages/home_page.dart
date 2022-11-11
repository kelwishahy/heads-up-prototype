import 'package:flutter/material.dart';
import 'package:heads_up_prototype/components/add_task_dialog.dart';
import 'package:heads_up_prototype/components/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List tasks = [
    ['Do Readings', DateTime(2022, 11, 19), 3],
    ['Leetcode Practice', DateTime(2022, 12, 12), 60],
    ['Midterm', DateTime(2022, 11, 17), 10],
    ['Quiz', DateTime(2022, 11, 24), 4],
  ];

  final _taskNameController = TextEditingController();
  final _hoursToCompleteController = TextEditingController();
  DateTime? dueDate;

  // Set date callback
  setDueDate(DateTime date) {
    setState(() {
      dueDate = date;
    });
  }

  // Save new task
  void saveNewTask() {
    setState(() {
      tasks.add([
        _taskNameController.text,
        dueDate,
        int.parse(_hoursToCompleteController.text)
      ]);
    });
    _taskNameController.clear();
    _hoursToCompleteController.clear();
    Navigator.of(context).pop();
  }

  // Add task method
  void addTask() {
    showDialog(
        context: context,
        builder: (context) {
          return AddTaskDialog(
            taskNameController: _taskNameController,
            hoursToCompleteController: _hoursToCompleteController,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
            setDate: setDueDate,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Heads Up'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addTask,
          backgroundColor: const Color(0xff2652cd),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return TaskCard(
                taskName: tasks[index][0],
                due: tasks[index][1],
                hoursToComplete: tasks[index][2]);
          },
        ));
  }
}
