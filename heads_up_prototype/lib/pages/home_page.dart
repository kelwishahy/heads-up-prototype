import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heads_up_prototype/components/add_task_dialog.dart';
import 'package:heads_up_prototype/components/task_card.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? timer;
  final Stopwatch stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
  }

  List tasks = [];

  final _taskNameController = TextEditingController();
  final _hoursToCompleteController = TextEditingController();
  final _timeUntilDueController = TextEditingController();
  DateTime dueDate = DateTime.now();

  // Set date callback
  setDueDate(DateTime date) {
    setState(() {
      dueDate = date;
    });
  }

  // Save new task
  void saveNewTask() {
    double whenToSend = (int.parse(_timeUntilDueController.text) -
        1.3 * int.parse(_hoursToCompleteController.text));
    setState(() {
      tasks.add([
        _taskNameController.text,
        int.parse(_timeUntilDueController.text),
        int.parse(_hoursToCompleteController.text),
        PausableTimer(
            Duration(minutes: max(whenToSend.ceil().toInt(), 0)), () => {})
      ]);
      tasks.sort((a, b) => a[1].compareTo(b[1]));
      // setDueDate(DateTime.now());
    });
    _taskNameController.clear();
    _hoursToCompleteController.clear();
    _timeUntilDueController.clear();
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
            timeUntilDueController: _timeUntilDueController,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
            setDate: setDueDate,
          );
        });
  }

  Duration? elapsedTime;
  void toggleTimer() {
    if (!stopwatch.isRunning) {
      stopwatch.start();
      Timer.periodic(Duration(seconds: 1), ((timer) {
        setState(() {
          elapsedTime = stopwatch.elapsed;
        });
      }));
    } else {
      stopwatch.stop();
    }

    if (timer == null) {
      timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
        setState(() {
          for (var task in tasks) {
            if (!task[3].isActive) task[3].start();
            if (task[1] > 0) task[1] -= 1;
          }
        });
      });
    } else {
      timer?.cancel();
      timer = null;
    }
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
            // Elapsed Time
            Text("${elapsedTime}"),
            // Timer toggle button
            FloatingActionButton(
              onPressed: () => toggleTimer(),
              backgroundColor: const Color(0xff2652cd),
              foregroundColor: Colors.white,
              child: const Icon(Icons.not_started),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            // Add task button
            FloatingActionButton(
              onPressed: addTask,
              backgroundColor: const Color(0xff2652cd),
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            ),
          ],
        ),
        // Task cards
        body: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              if (tasks[index][3].isExpired ||
                  tasks[index][3].duration <= const Duration(minutes: 1)) {
                return Dismissible(
                    key: Key(tasks[index][0]),
                    onDismissed: (direction) {
                      setState(() {
                        tasks.removeAt(index);
                      });
                    },
                    background: Container(color: Colors.red),
                    child: TaskCard(
                        taskName: tasks[index][0],
                        due: tasks[index][1],
                        hoursToComplete: tasks[index][2]));
              } else {
                return Container();
              }
            }));
  }
}
