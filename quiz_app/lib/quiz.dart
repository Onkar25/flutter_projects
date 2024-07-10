import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/questions_screen.dart';
import 'package:quiz_app/result_screen.dart';
import 'package:quiz_app/start_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  var activeScreen = 'start_screen';
  List<String> _selectedAnswers = [];
  @override
  void initState() {
    // activeScreen = StartScreen(switchScreen);
    super.initState();
  }

  void addAnswers(String answer) {
    _selectedAnswers.add(answer);
    if (_selectedAnswers.length == questions.length) {
      setState(() {
        // selectedAnswers = [];
        activeScreen = 'result_screen';
      });
    }
  }

  void switchScreen() {
    setState(() {
      activeScreen = 'question_screen';
    });
  }

  @override
  Widget build(context) {
    Widget screenWidget = StartScreen(switchScreen);
    if (activeScreen == 'question_screen') {
      screenWidget = QuestionsScreen(onSelectedAnswer: addAnswers);
    }

    if (activeScreen == 'result_screen') {
      screenWidget = ResultScreen(chosenAnswer: _selectedAnswers);
    }
    return MaterialApp(
      home: Scaffold(
          body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 1, 31, 255),
            Color.fromARGB(255, 255, 0, 0)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: screenWidget,
      )),
    );
  }
}
