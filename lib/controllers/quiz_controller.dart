import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';

class QuizController with ChangeNotifier {
  final List<QuizModel> _quizzes = [];

  List<QuizModel> get quizzes => List.unmodifiable(_quizzes);

  // Add methods to access specific quizzes
  QuizModel get generatedQuiz => _quizzes[0];
  QuizModel get revisionQuiz => _quizzes[1];
  bool isGeneratedQuiz(QuizModel quiz) => quiz == _quizzes[0];
  bool isRevisionQuiz(QuizModel quiz) => quiz == _quizzes[1];


  // Create predefined quiz types
  void initializeQuizzes() {
    _quizzes.addAll([
      _createGeneratedQuiz(),
      _createRevisionQuiz(),
      _createCustomQuiz(),
    ]);
    notifyListeners();
  }

  QuizModel _createGeneratedQuiz() {
    return QuizModel([
      QuestionModel(
          "Sample Generated Question 1",
          "A",
          {"A": "Correct", "B": "Wrong"}
      )
    ]);
  }

  QuizModel _createRevisionQuiz() {
    return QuizModel([
      QuestionModel(
          "Sample Revision Question 1",
          "B",
          {"A": "Incorrect", "B": "Correct"}
      )
    ]);
  }

  QuizModel _createCustomQuiz() {
    return QuizModel([
      QuestionModel(
          "Sample Custom Question 1",
          "C",
          {"A": "Option 1", "B": "Option 2", "C": "Right Answer"}
      )
    ]);
  }

  // Add a new custom quiz
  void addCustomQuiz(List<QuestionModel> questions) {
    _quizzes.add(QuizModel(questions));
    notifyListeners();
  }

  // Add a new empty quiz
  QuizModel addEmptyQuiz() {
    final newQuiz = QuizModel([]);
    _quizzes.add(newQuiz);
    notifyListeners();
    return newQuiz;
  }

  // Add a quiz with predefined questions
  QuizModel addQuizWithQuestions(List<QuestionModel> questions) {
    final newQuiz = QuizModel(questions);
    _quizzes.add(newQuiz);
    notifyListeners();
    return newQuiz;
  }

  // Add an existing quiz (for undo functionality)
  void addQuiz(QuizModel quiz) {
    _quizzes.add(quiz);
    notifyListeners();
  }

  /// Deletes a quiz by its ID
  void deleteQuiz(String quizId) {
    _quizzes.removeWhere((quiz) => quiz.id == quizId);
    notifyListeners();

    // Add Firestore deletion here if using database
    // await FirebaseFirestore.instance.collection('quizzes').doc(quizId).delete();
  }

  /// Deletes a quiz by its index (alternative approach)
  void deleteQuizAtIndex(int index) {
    if (index >= 0 && index < _quizzes.length) {
      _quizzes.removeAt(index);
      notifyListeners();
    }
  }

  // Navigate to quiz
  void navigateToQuiz(BuildContext context, String quizId) {
    Navigator.pushNamed(context, '/quiz', arguments: quizId);
  }
}