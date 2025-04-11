import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/course_model.dart';
import 'topic_list_view.dart';

class CourseListView extends StatelessWidget {
  const CourseListView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AppController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Your Subjects'),
        actions: [
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://dummyimage.com/600x400/000/fff.png',
              ),
            ),
            itemBuilder:
                (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'profile',
                    child: Text('Profile'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Provide Feedback',
                    child: Text('Provide Feedback'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
            onSelected: (value) async {
              if (value == 'logout') {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              }
              if (value == 'Provide Feedback') {
                Navigator.pushNamed(context, '/feedback');
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: ctrl.courses.length,
        itemBuilder: (BuildContext context, int index) {
          CourseModel course = ctrl.courses[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicListView(course: course),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.purple.shade50,
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(course.courseName[0]),
                  backgroundColor: Colors.purple.shade100,
                ),
                title: Text(course.courseName),
                subtitle: Text(course.subject),
                trailing: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: course.courseImage,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open add course page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
