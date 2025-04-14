import 'course_model.dart';
import 'subtopic_model.dart';
import 'package:uuid/uuid.dart';

class TopicModel {
  String id;
  CourseModel course;
  String topicName;
  List<SubtopicModel> subtopics;
  
  TopicModel(this.course, this.topicName, this.subtopics) : id = Uuid().v4();

    Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'course': course.id,
      'topicName': topicName,
      'subtopics': subtopics.map((st) => st.subtopicName).toList(),
    };
  }  
}