import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mindwave/controllers/app_controller.dart';
import 'package:mindwave/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class AddCourseView extends StatefulWidget {
  const AddCourseView({super.key});

  @override
  State<AddCourseView> createState() => _AddCourseViewState();
}

class _AddCourseViewState extends State<AddCourseView> {
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  List<File> _courseMaterial = [];
  bool _isLoading = false;
  bool _filesPicked = false;

  @override
  Widget build(BuildContext context) {
    final appCtrl = context.watch<AppController>();
    final authCtrl = context.watch<AuthController>();

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
                  setState(() {
                    _courseMaterial = result.paths.map((path) => File(path!)).toList();
                    _filesPicked = true;
                  });
                }
              },
              child: const Text('Upload Course Material (PDF)'),
            ),
            if (_filesPicked)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('✅ Files uploaded successfully!'),
              ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      final userId = authCtrl.currentUser!.uid;
                      await appCtrl.addCourse(
                        userId,
                        subjectController.text,
                        courseNameController.text,
                        _courseMaterial,
                      );
                      setState(() => _isLoading = false);
                      if (context.mounted) {
                        Navigator.pushNamed(context, '/home');
                      }
                    },
                    child: const Text('Submit'),
                  ),
          ],
        ),
      ),
    );
  }
}