import 'package:flutter/material.dart';
import 'package:mindwave/controllers/auth_controller.dart';
import 'package:mindwave/models/subtopic_model.dart';
import 'package:mindwave/views/add_course_view.dart';
import 'package:mindwave/views/feedback_view.dart';
import 'package:mindwave/views/login_view.dart';
import 'package:mindwave/views/quiz.dart';
import 'package:mindwave/views/quiz_view.dart';
import 'package:mindwave/views/signup_view.dart';
import 'package:mindwave/views/splash_screen.dart';
import 'package:mindwave/views/subtopic_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'controllers/app_controller.dart';
import 'views/course_list_view.dart';

import 'views/review_view.dart';

void main() async {
  // initialise firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Run app with controllers as notifier to change views
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginView(),
        '/signup': (context) => SignupView(),
        '/home': (context) => CourseListView(),
        '/subtopic': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final subtopic = args is SubtopicModel ? args : (args as Set).first as SubtopicModel;
          return SubtopicView(
            subtopic: subtopic,
          );
        },
        '/feedback': (context) => FeedbackView(),
        '/addCourse': (context) => AddCourseView(),
        '/quiz': (context) => QuizView(),
        '/quizStart': (context) => Quiz(),
        '/review': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return ReviewView(
            subtopicName: args['subtopicName']!,
            summary: args['summary']!,
          );
        },
      },
    );
  }
}
