import 'package:flutter/material.dart';
import 'package:heads_up_prototype/components/add_task_dialog.dart';
import 'package:heads_up_prototype/components/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List tasks = [];

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

  //dictate task
  void dictateTask() {
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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          verticalDirection: VerticalDirection.down,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: dictateTask,
              backgroundColor: const Color(0xff2652cd),
              foregroundColor: Colors.white,
              child: const Icon(Icons.mic),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            FloatingActionButton(
              onPressed: addTask,
              backgroundColor: const Color(0xff2652cd),
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            ),
          ],
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
