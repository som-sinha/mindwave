import 'question_model.dart';
import 'package:uuid/uuid.dart';

class QuizModel {
  String id;
  List<QuestionModel> questions;

  QuizModel(this.questions) : id = Uuid().v4();

  Map<String, dynamic> toFirestore() {
    return {
      'id' : id,
      'questions': questions.map((q) => q.toFirestore()).toList(),
    };
  }

}