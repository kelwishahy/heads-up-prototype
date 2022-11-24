import 'dart:async';
import 'dart:collection';
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
  // How many notifications are scheduled for a specific time
  final Map<double, double> notificationFrequency = HashMap();

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
    double whenToSend = double.parse(_timeUntilDueController.text) -
        1.7 * double.parse(_hoursToCompleteController.text);
    double notifTime = whenToSend.floor().toDouble();

    // Add the notification time to notification frequency map
    if (notificationFrequency.containsKey(notifTime)) {
      for (int i = notifTime.floor(); i > 0; i - 30) {
        if (notificationFrequency.containsKey(i)) {
          if (notificationFrequency[i]! < 2) {
            notifTime = i.toDouble();
            notificationFrequency.update(notifTime, (value) => value + 1);
          } else {
            continue;
          }
        } else {
          notifTime = i.toDouble();
          notificationFrequency.putIfAbsent(notifTime, () => 1);
        }
      }
    }

    // Add task to tasks list
    setState(() {
      tasks.add([
        _taskNameController.text,
        double.parse(_timeUntilDueController.text),
        double.parse(_hoursToCompleteController.text),
        PausableTimer(
            Duration(seconds: max((notifTime * 60).toInt(), 0)), () => {})
      ]);

      // sort tasks list by earliest notification time
      tasks.sort((a, b) {
        int cmp = a[3].duration.compareTo(b[3].duration);
        if (cmp != 0) return cmp;
        return a[1].compareTo(b[1]);
      });
    });

    // clear controllers and return to home page
    _taskNameController.clear();
    _hoursToCompleteController.clear();
    _timeUntilDueController.clear();
    Navigator.of(context).pop();
    // print("------UPDATED TASK NOTIFICATIONS-----");
    // for (var task in tasks) {
    //   print(task[0] + ", sending in: " + task[3].duration.inSeconds.toString());
    // }
  }

  //show added tasks
  void showTasks() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
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
                    }),
              ));
        });
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
    // Running time
    if (!stopwatch.isRunning) {
      stopwatch.start();
      // Update elapsed time variable every second
      Timer.periodic(Duration(seconds: 1), ((timer) {
        setState(() {
          elapsedTime = stopwatch.elapsed;
        });
      }));
      // Start the time until due timer for each task
      for (var task in tasks) {
        task[3].start();
      }
    } else {
      stopwatch.stop();
      // Pause the time until due timer for each task
      for (var task in tasks) {
        task[3].pause();
      }
    }

    // Decrement time until due every minute for each task
    if (timer == null) {
      timer = Timer.periodic(const Duration(seconds: 30), (Timer t) {
        setState(() {
          for (var task in tasks) {
            if (task[1] > 0) {
              task[1] -= 0.5;
            } else {
              task[1] = 0;
            }
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
            // See inputted tasks
            FloatingActionButton(
              onPressed: showTasks,
              backgroundColor: const Color(0xff2652cd),
              foregroundColor: Colors.white,
              child: const Icon(Icons.list),
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
                  tasks[index][3].duration <= const Duration(seconds: 60) &&
                      tasks[index][1] > 0) {
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
