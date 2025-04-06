import 'course_model.dart';
import 'subtopic_model.dart';
import 'package:uuid/uuid.dart';

class TopicModel {
  String id;
  CourseModel course;
  String topicName;
  List<SubtopicModel> quizzes;
  
  TopicModel(this.course, this.topicName, this.quizzes) : id = Uuid().v4();

    Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'course': course.id,
      'topicName': topicName,
      'quizzes': quizzes.map((q) => q.id).toList(),
    };
  }  
}