import 'question_model.dart';
import 'package:uuid/uuid.dart';

class QuizModel {
  String id;
  List<QuestionModel> questions;

  QuizModel(this.questions) : id = Uuid().v4();
}