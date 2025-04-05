import 'quiz_model.dart';
import 'topic_model.dart';
import 'package:uuid/uuid.dart';

class SubtopicModel {
  String id;
  TopicModel topic;
  String subtopicName;
  List<QuizModel> userQuizzes;
  QuizModel genQuiz;
  QuizModel reviewQuiz;
  
  SubtopicModel(this.topic, this.subtopicName, this.userQuizzes, this.genQuiz, this.reviewQuiz) : id = Uuid().v4();
}