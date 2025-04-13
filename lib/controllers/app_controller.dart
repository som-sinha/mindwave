import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/course_model.dart';
import '../models/topic_model.dart';
import '../models/subtopic_model.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';

class AppController extends ChangeNotifier {
  List<CourseModel> courses = [];

  AppController() {
    _loadDummyData();
  }

  void _loadDummyData() {
    // Dummy quiz
    final dummyQuiz = QuizModel([
      QuestionModel('What is Flutter?', 'A UI toolkit', {
        'A': 'A programming language',
        'B': 'A database',
        'C': 'A UI toolkit',
        'D': 'An IDE',
      }),
    ]);

    // Temporary placeholder course to satisfy non-nullable reference
    final placeholderCourse = CourseModel(
      'Placeholder Subject',
      'Placeholder Course',
      Image.network("https://dummyimage.com/600x400/000/fff.png"),
      [],
      'Temporary course for linking',
      [],
    );

    // Temporary topics (will update course link later)
    final topic1 = TopicModel(placeholderCourse, 'Introduction and Setup', []);
    final topic2 = TopicModel(placeholderCourse, 'Flutter Widgets', []);

    // Subtopics
    final sub1 = SubtopicModel(
      topic1,
      'Getting Started with Flutter',
      [],
      dummyQuiz,
      dummyQuiz,
    );
    final sub2 = SubtopicModel(
      topic2,
      'Understanding Widgets',
      [],
      dummyQuiz,
      dummyQuiz,
    );

    // Assign subtopics to topics
    topic1.quizzes.add(sub1);
    topic2.quizzes.add(sub2);

    // Real course now that topics exist
    final course = CourseModel(
      'Mobile Development',
      'Flutter Bootcamp',
      Image.network("https://dummyimage.com/600x400/000/fff.png"),
      [],
      'A complete introduction to mobile development with Flutter.',
      [topic1, topic2],
    );

    // Link topics back to actual course
    topic1.course = course;
    topic2.course = course;

    // Update course reference in subtopics
    sub1.topic = topic1;
    sub2.topic = topic2;

    // Add to controller
    courses.add(course);
    notifyListeners();
  }

  // Unchanged methods
  addCourse(subject, courseName, courseMaterial) {
    var (courseDescription, topics) = _processCourseMaterial(
      subject,
      courseName,
      courseMaterial,
    );

    Image courseImage = Image.network(
      "https://dummyimage.com/600x400/000/fff.png",
    );

    CourseModel course = CourseModel(
      subject,
      courseName,
      courseImage,
      courseMaterial,
      courseDescription,
      topics,
    );
  }

  removeCourse() {}

  getCourses() {}

  (String, List<TopicModel>) _processCourseMaterial(subject, courseName, courseMaterial,) async {
    final requestUrl = Uri.parse('');
    
    return ('', []);
  }
}
