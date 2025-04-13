import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';

class QuizController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _quizzesCollection = FirebaseFirestore.instance.collection('quizzes');

  List<QuizModel> _quizzes = [];
  List<QuizModel> get quizzes => List.unmodifiable(_quizzes);

  // Initialize quizzes from Firestore
  Future<void> initializeQuizzes() async {
    try {
      final snapshot = await _quizzesCollection.get();
      if (snapshot.docs.isEmpty) {
        // If no quizzes exist, create sample quizzes
        await _createSampleQuizzes();
      } else {
        // Load quizzes from Firestore
        _quizzes = snapshot.docs.map((doc) {
          return QuizModel.fromFirestore(doc.data() as Map<String, dynamic>);
        }).toList();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing quizzes: $e');
      // Fallback to local samples if Firestore fails
      _quizzes.addAll([
        _createGeneratedQuiz(),
        _createRevisionQuiz(),
        _createCustomQuiz(),
      ]);
      notifyListeners();
    }
  }

  Future<void> _createSampleQuizzes() async {
    _quizzes.addAll([
      _createGeneratedQuiz(),
      _createRevisionQuiz(),
      _createCustomQuiz(),
    ]);
    // Save samples to Firestore
    final batch = _firestore.batch();
    for (final quiz in _quizzes) {
      batch.set(_quizzesCollection.doc(quiz.id), quiz.toFirestore());
    }
    await batch.commit();
  }

  // Quiz creation methods
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

  QuizModel? get generatedQuiz => _quizzes.isNotEmpty ? _quizzes.firstWhere(
        (quiz) => quiz.id == 'generated_quiz_id', // Add a way to identify generated quizzes
    orElse: () => _createGeneratedQuiz(),
  ) : null;

  QuizModel? get revisionQuiz => _quizzes.isNotEmpty ? _quizzes.firstWhere(
        (quiz) => quiz.id == 'revision_quiz_id', // Add a way to identify revision quizzes
    orElse: () => _createRevisionQuiz(),
  ) : null;

  // Add a new quiz to Firestore
  Future<QuizModel> addQuiz(List<QuestionModel> questions) {
    return addQuizFromModel(QuizModel(questions));
  }

  Future<QuizModel> addQuizFromModel(QuizModel quiz) async {
    try {
      await _quizzesCollection.doc(quiz.id).set(quiz.toFirestore());
      await _refreshQuizzes();
      return quiz;
    } catch (e) {
      debugPrint('Error adding quiz: $e');
      throw Exception('Failed to add quiz');
    }
  }

  // Delete a quiz from Firestore
  Future<void> deleteQuiz(String quizId) async {
    try {
      await _quizzesCollection.doc(quizId).delete();
      await _refreshQuizzes(); // Reload from Firestore
    } catch (e) {
      debugPrint('Error deleting quiz: $e');
      throw Exception('Failed to delete quiz');
    }
  }

  // Add question to an existing quiz in Firestore
  Future<void> addQuestion(String quizId, QuestionModel question) async {
    try {
      await _quizzesCollection.doc(quizId).update({
        'questions': FieldValue.arrayUnion([question.toFirestore()])
      });
      await _refreshQuizzes(); // Reload from Firestore
    } catch (e) {
      debugPrint('Error adding question: $e');
      throw Exception('Failed to add question');
    }
  }

  // Get real-time updates stream
  Stream<List<QuizModel>> get quizzesStream {
    return _quizzesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return QuizModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Refresh quizzes from Firestore
  Future<void> _refreshQuizzes() async {
    final snapshot = await _quizzesCollection.get();
    _quizzes = snapshot.docs.map((doc) {
      return QuizModel.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();
    notifyListeners();
  }

  // Navigation method
  void navigateToQuiz(BuildContext context, String quizId) {
    Navigator.pushNamed(context, '/quiz', arguments: quizId);
  }
}