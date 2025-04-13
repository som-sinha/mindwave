import 'package:uuid/uuid.dart';

class QuestionModel {
  String id;
  String question;
  Map <String, String> options;
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
      data['question'] as String,
      data['correctOption'] as String,
      Map<String, String>.from(data['options'] as Map),
    );
  }

  QuestionModel copyWith({
    String? question,
    Map<String, String>? options,
    String? correctOption,
  }) {
    return QuestionModel(
      question ?? this.question,
      correctOption ?? this.correctOption,
      options ?? this.options,
    );
  }
}