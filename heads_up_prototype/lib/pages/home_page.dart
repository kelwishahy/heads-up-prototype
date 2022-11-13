import 'package:flutter/material.dart';
import 'package:heads_up_prototype/components/add_task_dialog.dart';
import 'package:heads_up_prototype/components/task_card.dart';
import 'package:heads_up_prototype/pages/dictate_task_page.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Speech to text stuff
  final SpeechToText _speechToText = SpeechToText();
  String voice_task = '';
  String voice_dueDate = '';
  int voice_hours = 1;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  List tasks = [];

  final _taskNameController = TextEditingController();
  final _hoursToCompleteController = TextEditingController();
  DateTime dueDate = DateTime.now();

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
        DateFormat.yMMMMd('en_US').format(dueDate),
        int.parse(_hoursToCompleteController.text)
      ]);
      setDueDate(DateTime.now());
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
  Future<void> dictateTask(BuildContext context) async {
    final voiceInput = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DictatePage(
                stt: _speechToText,
              )),
    );

    setState(() {
      voice_task = voiceInput[0];
      voice_dueDate = voiceInput[1];
      voice_hours =
          int.parse(voiceInput[2].replaceAll(new RegExp(r'[^0-9]'), ''));

      tasks.add([voice_task, voice_dueDate, voice_hours]);
    });

    debugPrint(tasks.last);
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
              onPressed: () => dictateTask(context),
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
            return Dismissible(
                key: Key(tasks[index][0]),
                onDismissed: (direction) {
                  setState(() {
                    tasks.removeAt(index);
                  });

                  // Then show a snackbar.
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task deleted')));
                },
                background: Container(color: Colors.red),
                child: TaskCard(
                    taskName: tasks[index][0],
                    due: tasks[index][1],
                    hoursToComplete: tasks[index][2]));
          },
        ));
  }
}
