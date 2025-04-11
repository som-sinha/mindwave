import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';

class QuizController {
  final List<QuizModel> _quizzes = [];

  // Getter for quizzes (unmodifiable)
  List<QuizModel> get quizzes => List.unmodifiable(_quizzes);

  // Create a new quiz with questions
  QuizModel createQuiz(List<QuestionModel> questions) {
    if (questions.isEmpty) {
      throw ArgumentError("Quiz must contain at least one question");
    }

    final newQuiz = QuizModel(questions);
    _quizzes.add(newQuiz);
    return newQuiz;
  }

  // Add question to existing quiz
  void addQuestion(String quizId, QuestionModel question) {
    final quiz = _quizzes.firstWhere(
            (q) => q.id == quizId,
        orElse: () => throw ArgumentError("Quiz not found")
    );

    quiz.questions.add(question);
  }

  // Get quiz by ID
  QuizModel getQuiz(String quizId) {
    return _quizzes.firstWhere(
            (q) => q.id == quizId,
        orElse: () => throw ArgumentError("Quiz not found")
    );
  }

  // Initialize with sample data
  void initializeSampleQuizzes() {
    final sampleQuestions = [
      QuestionModel(
        "What is 2+2?",
        "A",
        {"A": "4", "B": "22", "C": "5"},
      ),
      QuestionModel(
        "Capital of France?",
        "B",
        {"A": "London", "B": "Paris", "C": "Berlin"},
      ),
    ];

    _quizzes.add(QuizModel(sampleQuestions));
  }
}