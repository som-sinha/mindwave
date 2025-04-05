import 'dart:io';
import 'package:flutter/material.dart';
import 'topic_model.dart';
import 'package:uuid/uuid.dart';

class CourseModel {
  String id;
  String subject;
  String courseDescription;
  List<TopicModel> topics;
  String courseName;
  Image courseImage;
  List<File> courseMaterial;
 
  CourseModel(this.subject, this.courseName, this.courseImage, this.courseMaterial, this.courseDescription, this.topics) : id = Uuid().v4();
}