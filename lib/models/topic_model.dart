import 'course_model.dart';
import 'subtopic_model.dart';
import 'package:uuid/uuid.dart';

class TopicModel {
  String id;
  CourseModel course;
  String topicName;
  List<SubtopicModel> quizzes;
  
  TopicModel(this.course, this.topicName, this.quizzes) : id = Uuid().v4();
}