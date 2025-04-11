import 'package:flutter/material.dart';
import 'package:mindwave/models/topic_model.dart';

import '../models/course_model.dart';

class AppController extends ChangeNotifier {
  List<CourseModel> courses = [];

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

  (String, List<TopicModel>) _processCourseMaterial(
    subject,
    courseName,
    courseMaterial,
  ) {
    return ('', []);
  }
}
