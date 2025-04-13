import 'package:flutter/material.dart';
import 'package:mindwave/models/topic_model.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../models/course_model.dart';
import '../models/topic_model.dart';
import '../models/subtopic_model.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';

class AppController extends ChangeNotifier {
  List<CourseModel> courses = [];
  FirebaseFunctions functions = FirebaseFunctions.instance;

  addCourse(subject, courseName, courseMaterial) {
    var (courseDescription, topics) = _processCourseMaterial(
      subject,
      courseName,
      courseMaterial,
    );

    Image courseImage = Image.network(
      "https://dummyimage.com/600x400/000/fff.png",
    );

    CourseModel course = CourseModel(subject, courseName, courseImage, courseMaterial, courseDescription, topics);


  }

  removeCourse() {

  }

  getCourses() {

  }

_processCourseMaterial(subject, courseName,  courseMaterial) async {
    
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('processCourseOutline');

    final result = await callable();
    
    return ('', []);
  }
}
