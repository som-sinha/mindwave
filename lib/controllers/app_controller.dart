import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
            topic: t['topic']['topicName'],
            subtopicName: st['subtopicName'],
            description: st['description'],
            userQuizzes: [],
            genQuiz: QuizModel((genQuiz as List).map((q) => QuestionModel(
              q['questionText'],
              q['correctOption'],
              (q['options'] as List).cast<String>(),
            )).toList()),
            reviewQuiz: QuizModel([]),
          ));
      }
      topics.add(TopicModel(t['topic']['topicName'], subtopics));
    }
    course.topics = topics;
    await _uploadToFirestore(userId, course);

    courses.add(course);
  }

  removeCourse() {

  }

  fetchCourses(String userId) async {
    final courseSnapshots = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('courses')
        .get();

    courses.clear();

    for (final courseDoc in courseSnapshots.docs) {
      final courseData = courseDoc.data();
      final course = CourseModel(
        courseData['subject'] ?? '',
        courseData['courseName'] ?? '',
        List<String>.from(courseData['courseMaterial'] ?? []),
        [],
      )..id = courseData['id'];

      courses.add(course);
    }

    notifyListeners();
  }

  Future<List<TopicModel>> fetchTopics(String userId, String courseId) async {
    final topicSnapshots = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('courses')
        .doc(courseId)
        .collection('topics')
        .get();

    List<TopicModel> fetchedTopics = [];

    for (final topicDoc in topicSnapshots.docs) {
      final topicData = topicDoc.data();
      final subtopicSnapshots = await topicDoc.reference.collection('subtopics').get();

      List<SubtopicModel> subtopics = [];

      for (final subDoc in subtopicSnapshots.docs) {
        final subData = subDoc.data();
        final genQuiz = await fetchQuizById(
          userId,
          courseId,
          topicData['id'],
          subData['id'],
          subData['genQuiz']["id"],
        );
        final reviewQuiz = await fetchQuizById(
          userId,
          courseId,
          topicData['id'],
          subData['id'],
          subData['reviewQuiz']["id"],
        );

        subtopics.add(SubtopicModel(
          topic: subData['topic'],
          subtopicName: subData['subtopicName'] ?? '',
          description: subData['description'] ?? '',
          userQuizzes: subData['userQuizz'] ?? [],
          genQuiz: genQuiz ?? QuizModel([]),
          reviewQuiz: reviewQuiz ?? QuizModel([]),
        )..id = subData['id']);
      }

      fetchedTopics.add(TopicModel(topicData['topicName'] ?? '', subtopics)..id = topicData['id']);
    }

    return fetchedTopics;
  }

  Future<List<QuizModel>> fetchQuizzes(String userId, String courseId, String topicId, String subtopicId) async {
    final quizList = <QuizModel>[];

    final quizSnapshots = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('courses')
        .doc(courseId)
        .collection('topics')
        .doc(topicId)
        .collection('subtopics')
        .doc(subtopicId)
        .collection('quizzes')
        .get();

    for (final quizDoc in quizSnapshots.docs) {
      final quizData = quizDoc.data();
      final questions = (quizData['questions'] as List).map((q) {
        return QuestionModel(
          q['question'] ?? '',
          q['correctOption'] ?? '',
          List<String>.from(q['options'] ?? []),
        );
      }).toList();

      quizList.add(QuizModel(questions)..id = quizDoc.id);
    }

    return quizList;
  }

  Future<SubtopicModel?> fetchSubtopic(String userId, String courseId, String topicId, String subtopicId) async {
    final subtopicDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('courses')
        .doc(courseId)
        .collection('topics')
        .doc(topicId)
        .collection('subtopics')
        .doc(subtopicId)
        .get();

    if (subtopicDoc.exists) {
      final data = subtopicDoc.data()!;
      return SubtopicModel(
        topic: data['topic'],
        subtopicName: data['subtopicName'] ?? '',
        description: data['description'] ?? '',
        userQuizzes: data['userQuizz'] ?? [],
        genQuiz: data['genQuiz'],
        reviewQuiz: data['reveiwQuiz'],
      )..id = data['id'];
    }
    return null;
  }

  Future<QuizModel?> fetchQuizById(String userId, String courseId, String topicId, String subtopicId, String quizId) async {
    final quizDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('courses')
        .doc(courseId)
        .collection('topics')
        .doc(topicId)
        .collection('subtopics')
        .doc(subtopicId)
        .collection('quizzes')
        .doc(quizId)
        .get();

    if (quizDoc.exists) {
      final quizData = quizDoc.data()!;
      final questions = (quizData['questions'] as List).map((q) {
        return QuestionModel(
          q['question'] ?? '',
          q['correctOption'] ?? '',
          List<String>.from(q['options'] ?? []),
        );
      }).toList();

      return QuizModel(questions)..id = quizDoc.id;
    }

    return null;
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
