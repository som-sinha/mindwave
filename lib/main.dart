import 'package:flutter/material.dart';
import 'View/quiz-view.dart';
import 'View/quiz.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => QuizView(),
        '/quiz': (context) => Quiz(),
      },
    );
  }
}

