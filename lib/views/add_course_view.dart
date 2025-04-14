import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mindwave/controllers/app_controller.dart';
import 'package:mindwave/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class AddCourseView extends StatelessWidget {
  const AddCourseView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController courseNameController = TextEditingController();
    final TextEditingController subjectController = TextEditingController();
    final appCtrl = context.watch<AppController>();
    final authCtrl = context.watch<AuthController>();
    List<File> courseMaterial = [];

    return Scaffold(
      appBar: AppBar(title: const Text('Add Course')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: courseNameController,
              decoration: const InputDecoration(labelText: 'Course Name'),
            ),
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                  allowMultiple: true,
                );

                if (result != null) {
                  courseMaterial = result.paths.map((path) => File(path!)).toList();
                }
              },
              child: const Text('Upload Course Material (PDF)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                var userId = authCtrl.currentUser!.uid;
                appCtrl.addCourse(userId, subjectController.text, courseNameController.text, courseMaterial);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}