import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Map<String, dynamic> toFirestore() {
  return {
    'id': id,
    'subject': subject,
    'courseDescription': courseDescription,
    'courseName': courseName,
    
    // ⚠️ Replace this with the actual uploaded image URL
    'courseImageUrl': 'https://your-firebase-storage.com/image.jpg',
    
    // ⚠️ Upload files and replace with URLs
    'courseMaterialUrls': courseMaterial.map((file) => file.path).toList(),

    // Convert nested TopicModels
    'topics': topics.map((topic) => topic.id).toList(),
  };
}  
}