import 'topic_model.dart';
import 'package:uuid/uuid.dart';

class CourseModel {
  String id;
  String subject;
  List<TopicModel> topics;
  String courseName;
  List<String> courseMaterial;
 
  CourseModel(this.subject, this.courseName, this.courseMaterial, this.topics) : id = Uuid().v4();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'subject': subject,
      'courseName': courseName,
      'courseMaterialUrls': courseMaterial,
      'topics': topics.map((topic) => topic.id).toList(),
    };
  }  

  factory CourseModel.fromFirestore(Map<String, dynamic> data) {
    return CourseModel(
      data['subject'] ?? '',
      data['courseName'] ?? '',
      List<String>.from(data['courseMaterialUrls'] ?? []),
      [], // Topics should be fetched separately
    )..id = data['id'] ?? Uuid().v4();
  }
}