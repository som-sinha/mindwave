import 'package:uuid/uuid.dart';

class QuestionModel {
  String id;
  String question;
  Map <String, String> options;
  String correctOption;

  QuestionModel(this.question, this.correctOption, this.options) : id = Uuid().v4();
}