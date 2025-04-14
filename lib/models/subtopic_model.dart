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
  
  SubtopicModel(this.topic, this.subtopicName, this.description, this.userQuizzes, this.genQuiz, this.reviewQuiz) : id = Uuid().v4();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'subtopicName': subtopicName,
      'description': description,
      'topic': topic,
      'userQuizzes': userQuizzes.map((q) => q.id).toList(),
      'genQuiz': genQuiz.id,
      'reviewQuiz': reviewQuiz.id,
    };
  }  
}