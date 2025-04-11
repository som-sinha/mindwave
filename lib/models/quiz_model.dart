import 'question_model.dart';
import 'package:uuid/uuid.dart';

class QuizModel {
  String id;
  List<QuestionModel> questions;

  QuizModel(this.questions, {String? id,}) : id = id ?? Uuid().v4();

  Map<String, dynamic> toFirestore() {
    return {
      'id' : id,
      'questions': questions.map((q) => q.toFirestore()).toList(),
    };
  }

<<<<<<< HEAD
=======
  // Create from Firestore data
  factory QuizModel.fromFirestore(Map<String, dynamic> data) {
    try {
      // Parse questions from Firestore format
      final questions = (data['questions'] as List).map((qData) {
        return QuestionModel.fromFirestore(
            qData is Map<String, dynamic>
                ? qData
                : Map<String, dynamic>.from(qData as Map)
        );
      }).toList();

      return QuizModel(
        questions,
        id: data['id']?.toString(),
      );
    } catch (e, stack) {
      print('Error parsing QuizModel: $e\n$stack');
      rethrow;
    }
  }

  // Helper to create a copy with modified fields
  QuizModel copyWith({
    List<QuestionModel>? questions,
    String? id,
  }) {
    return QuizModel(
      questions ?? this.questions,
      id: id ?? this.id,
    );
  }
>>>>>>> 4e7ce77 (Fourth commit - modified quiz and question code to integrate firebase.)
}