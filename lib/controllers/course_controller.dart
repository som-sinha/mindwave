import 'package:flutter/material.dart';

import '../models/course_model.dart';

class CourseController {
  List<CourseModel> courses = [];

  // Creating Dummy Courses
  CourseModel course1 = CourseModel("Computer Science", "COMP 4768: Software Development for Mobile Devices", 
  Image.network('https://placehold.co/600x400/png'), [], "blah blah blah", []);
  
  CourseModel course2 = CourseModel("English", "English 4768: Software Development for Shakespear", 
  Image.network('https://placehold.co/600x400/png'), [], "blah blah blah", []);

  
  
  
}