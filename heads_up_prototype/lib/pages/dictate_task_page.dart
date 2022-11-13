import 'package:flutter/material.dart';
import 'package:heads_up_prototype/components/button.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter/foundation.dart';

enum input { TASK, DUE, HOURS, NONE }

class DictatePage extends StatefulWidget {
  final SpeechToText stt;
  const DictatePage({super.key, required this.stt});

  @override
  State<DictatePage> createState() => _DictatePageState();
}

class _DictatePageState extends State<DictatePage> {
  String _lastWords = '';
  String _task = '';
  String _dueDate = '';
  String _hoursToComplete = '';
  bool isListening = false;
  input current = input.TASK;

  void _toggleListening() async {
    setState(() {
      isListening = !isListening;
    });

    if (isListening) {
      _startListening();
    } else {
      _stopListening();
    }
  }

  void _startListening() async {
    await widget.stt.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await widget.stt.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      if (result.finalResult) {
        debugPrint(_lastWords);

        if (current == input.TASK) {
          _task = _lastWords;
        } else if (current == input.DUE) {
          _dueDate = _lastWords;
        } else if (current == input.HOURS) {
          _hoursToComplete = _lastWords;
        }
        _toggleListening();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add a task'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  // Spoken Text
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        // Task
                        SingleChildScrollView(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              children: [
                                const Text(
                                  "What's the task?",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 24),
                                ),
                                Text(
                                  _task,
                                  style: const TextStyle(
                                      color: Color(0xff2652cd), fontSize: 24),
                                ),
                              ],
                            )),
                        // Due date
                        SingleChildScrollView(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              children: [
                                const Text(
                                  "When is it due?",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 24),
                                ),
                                Text(
                                  _dueDate,
                                  style: const TextStyle(
                                      color: Color(0xff2652cd), fontSize: 24),
                                ),
                              ],
                            )),
                        // Hours to Complete
                        SingleChildScrollView(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              children: [
                                const Text(
                                  "How long will it take?",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 24),
                                ),
                                Text(
                                  _hoursToComplete,
                                  style: const TextStyle(
                                      color: Color(0xff2652cd), fontSize: 24),
                                ),
                              ],
                            )),
                      ])),

                  // Microphone Buttons
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Task
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: FloatingActionButton(
                            elevation: 1,
                            backgroundColor: const Color(0xff2652cd),
                            foregroundColor: Colors.white,
                            child: const Icon(Icons.mic),
                            onPressed: () async {
                              current = input.TASK;
                              _toggleListening();
                            }),
                      ),

                      // Due Date
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: FloatingActionButton(
                            elevation: 1,
                            backgroundColor: const Color(0xff2652cd),
                            foregroundColor: Colors.white,
                            child: const Icon(Icons.mic),
                            onPressed: () {
                              current = input.DUE;
                              _toggleListening();
                            }),
                      ),
                      // Hours to complete
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: FloatingActionButton(
                            elevation: 1,
                            backgroundColor: const Color(0xff2652cd),
                            foregroundColor: Colors.white,
                            child: const Icon(Icons.mic),
                            onPressed: () {
                              current = input.HOURS;
                              _toggleListening();
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child:
                  Text(isListening ? 'Listening...' : 'Press button to answer'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Button(
                      buttonText: 'Cancel',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      colour: Colors.red),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Button(
                      buttonText: 'Give me a heads up!',
                      onPressed: () {
                        Navigator.pop(
                            context, [_task, _dueDate, _hoursToComplete]);
                      },
                      colour: Colors.green),
                ),
              ],
            )
          ],
        ));
  }
}
