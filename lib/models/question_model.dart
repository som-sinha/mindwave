import 'package:uuid/uuid.dart';

class QuestionModel {
  String id;
  String question;
  List<String> options;
  String correctOption;

  QuestionModel(this.question, this.correctOption, this.options) : id = Uuid().v4();

  Map<String, dynamic> toFirestore() {
    return {
      'id' : id,
      'question' : question,
      'options': options,
      'correctOption': correctOption
    };
  }
  
  factory QuestionModel.fromFirestore(Map<String, dynamic> data) {
    return QuestionModel(
      data['question'] ?? '',
      data['correctOption'] ?? '',
      (data['options'] as List<dynamic>).cast<String>(),
    )..id = data['id'] ?? Uuid().v4();
  }

}