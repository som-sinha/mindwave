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
      backgroundColor: const Color(0xFFF8EDF8), // Soft purple background
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Your Subjects',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
        padding: const EdgeInsets.all(16),
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
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.purple.shade100,
                    child: Text(course.courseName[0]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.courseName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          course.subject,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: course.courseImage,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple.shade200,
        onPressed: () {
          // TODO: Add course logic
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
