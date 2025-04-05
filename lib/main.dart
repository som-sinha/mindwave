import 'package:flutter/material.dart';
import 'controllers/course_controller.dart';
import 'views/course_list_view.dart';

void main() {
  final CourseController cctrl = CourseController();
  runApp(MainApp(controller: cctrl));
}

class MainApp extends StatelessWidget {
  final CourseController controller;
  const MainApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CourseListView(ctrl: controller,),
    );
  }
}