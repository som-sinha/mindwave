import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mindwave/controllers/auth_controller.dart';
import 'package:mindwave/views/feedback_view.dart';
import 'package:mindwave/views/login_view.dart';
import 'package:mindwave/views/signup_view.dart';
import 'package:mindwave/views/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'controllers/app_controller.dart';
import 'views/course_list_view.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginView(),
        '/signup': (context) => SignupView(),
        '/home': (context) => CourseListView(),
        '/feedback': (context) => FeedbackView(),
      }
    );
  }
}