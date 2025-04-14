import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mindwave/controllers/auth_controller.dart';
import 'package:mindwave/models/question_model.dart';
import 'package:mindwave/models/quiz_model.dart';
import 'package:mindwave/models/subtopic_model.dart';
import 'package:mindwave/models/topic_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../models/course_model.dart';

class AppController extends ChangeNotifier {
  List<CourseModel> courses = [];
  FirebaseFunctions functions = FirebaseFunctions.instance;

  addCourse(userId, subject, courseName, courseMaterial) async {
    
    List<String> courseMaterialList = [];
    List<TopicModel> topics = [];

    
    final mergedPdf = await _joinPdfs(courseMaterial);
    final mergedCourseMaterialLink = await _uploadToFirebaseStorage(mergedPdf, '$courseName-AllMaterials.pdf', userId, courseName);
    
    for (var file in courseMaterial)
    {
      courseMaterialList.add(await _uploadToFirebaseStorage(file, file.toString(), userId, courseName));
    }
    
    final genVal = await _processCourseMaterial(
      userId,
      subject,
      courseName,
      mergedCourseMaterialLink,
    );

    CourseModel course = CourseModel(subject, courseName, courseMaterialList, []);

    for (var t in genVal)
    {
      List<SubtopicModel> subtopics = [];
      for (var st in t['topic']['subtopics'])
      {
          final genQuiz = await _generateQuiz(st['subtopicName'], st['description'], mergedCourseMaterialLink);
          subtopics.add(SubtopicModel(
            t['topic']['topicName'],
            st['subtopicName'],
            st['description'],
            [],
            QuizModel((genQuiz as List).map((q) => QuestionModel(
              q['questionText'],
              q['correctOption'],
              (q['options'] as List).cast<String>(),
            )).toList()),
            QuizModel([]),
          ));
      }
      topics.add(TopicModel(course, t['topic']['topicName'], subtopics));
    }
    course.topics = topics;
    await _uploadToFirestore(userId, course);
  }

  removeCourse() {

  }

  getCourses() {

  }

  _processCourseMaterial(userId, subject, courseName, mergedCourseMaterialLink) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('processCourseMaterial');

    final result = await callable.call({
      'courseName': courseName,
      'subject': subject,
      'material': mergedCourseMaterialLink,
    });

    return result.data;
  }

  _generateQuiz(subtopicName, subtopicDescription, mergedCourseMaterialLink) async {
  try {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('generateSubtopicQuiz');

    final result = await callable.call({
      'courseMaterial': mergedCourseMaterialLink,
      'subtopicName': subtopicName,
      'subtopicDescription': subtopicDescription,
    });

    return result.data;
  } catch (e) {
    debugPrint('🔥 Error calling generateSubtopicQuiz: $e');
    rethrow;
  }
}

  _uploadToFirebaseStorage(File file, String fileName, userId, courseName) async {
    final ref = FirebaseStorage.instance.ref().child('$userId/$courseName/$fileName');
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  _uploadToFirestore(String userId, CourseModel course) async {
    final courseRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('courses')
        .doc(course.id);

    await courseRef.set(course.toFirestore());

    for (final topic in course.topics) {
      final topicRef = courseRef.collection('topics').doc(topic.id);
      await topicRef.set(topic.toFirestore());

      for (final subtopic in topic.subtopics) {
        final subtopicRef = topicRef.collection('subtopics').doc(subtopic.id);
        await subtopicRef.set(subtopic.toFirestore());

        final quizRef = subtopicRef.collection('quizzes').doc(subtopic.genQuiz.id);
        await quizRef.set(subtopic.genQuiz.toFirestore());
      }
    }
  }

  _joinPdfs(List<File> pdfFiles) async {
    final PdfDocument outputDocument = PdfDocument();

    for (final file in pdfFiles) {
      final bytes = await file.readAsBytes();
      final PdfDocument inputDoc = PdfDocument(inputBytes: bytes);
      outputDocument.pages.add().graphics.drawPdfTemplate(
        inputDoc.pages[0].createTemplate(), const Offset(0, 0),
      );

      for (int i = 1; i < inputDoc.pages.count; i++) {
        outputDocument.pages.add().graphics.drawPdfTemplate(
          inputDoc.pages[i].createTemplate(), const Offset(0, 0),
        );
      }

      inputDoc.dispose();
    }

    final List<int> bytes = await outputDocument.save();
    outputDocument.dispose();

    final outputFile = File('${Directory.systemTemp.path}/merged.pdf');
    await outputFile.writeAsBytes(bytes);
    return outputFile;
  }
}
