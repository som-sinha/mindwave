import 'package:flutter/material.dart';
import '../controllers/course_controller.dart';

class CourseListView extends StatelessWidget {
  final CourseController ctrl;

  const CourseListView({super.key, required this.ctrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Your Subjects')),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: ctrl.courses.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(title: Text(ctrl.courses[index].courseName));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open add a course page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
