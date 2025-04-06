import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';

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
              backgroundImage: NetworkImage('https://dummyimage.com/600x400/000/fff.png'),
            ),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Settings'),
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
            },
          ),
        ],
      ),
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
