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
}