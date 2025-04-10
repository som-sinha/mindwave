import 'quiz_model.dart';
import 'package:uuid/uuid.dart';

class SubtopicModel {
  String id;
  String topic;
  String subtopicName;
  String description;
  List<QuizModel> userQuizzes;
  QuizModel genQuiz;
  QuizModel reviewQuiz;
  
  SubtopicModel({
    required this.topic,
    required this.subtopicName,
    required this.description,
    required this.userQuizzes,
    required this.genQuiz,
    required this.reviewQuiz,
  }) : id = Uuid().v4();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'subtopicName': subtopicName,
      'description': description,
      'topic': topic,
      'genQuiz': genQuiz.toFirestore(),
      'reviewQuiz': reviewQuiz.toFirestore(),
      'userQuizzes': userQuizzes.map((q) => q.toFirestore()).toList(),
    };
  }  
}