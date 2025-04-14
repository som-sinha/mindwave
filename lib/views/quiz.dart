import 'package:flutter/material.dart';
import '../utils/feedback_dialog.dart';
import '../models/quiz_model.dart';

class Quiz extends StatefulWidget {
  final QuizModel quiz;

  const Quiz({super.key, required this.quiz});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int _currentQuestionIndex = 0;
  String? _selectedOption;
  Set<int> _flaggedQuestions = {};
  Set<String> _correctAnswers = {};
  Set<String> _incorrectAnswers = {};

  void _showCorrectSplash() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green[100],
        title: Icon(Icons.check_circle_outline, color: Colors.green, size: 64),
        content: Text(
          'Correct!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  void _showIncorrectSplash() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red[100],
        title: Icon(Icons.cancel_outlined, color: Colors.red, size: 64),
        content: Text(
          'Incorrect!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        actions: [
          IconButton(
            icon: Icon(Icons.workspace_premium_outlined),
            tooltip: 'Upgrade to Pro',
            onPressed: () {
              Navigator.pushNamed(context, '/upgrade');
            },
          ),
          IconButton(
            icon: Icon(Icons.feedback_outlined),
            onPressed: () => showFeedbackDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz Name',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Text(
              'Q${_currentQuestionIndex + 1}. ${widget.quiz.questions[_currentQuestionIndex].question}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            ...widget.quiz.questions[_currentQuestionIndex].options.map((option) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 56),
                  backgroundColor: _selectedOption == option ? Colors.deepPurple : Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _selectedOption = option;
                  });
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(option, style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            )),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_flaggedQuestions.contains(_currentQuestionIndex)) {
                        _flaggedQuestions.remove(_currentQuestionIndex);
                      } else {
                        _flaggedQuestions.add(_currentQuestionIndex);
                      }
                    });
                  },
                  child: Text('Flag for revision'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedOption = null;
                      _currentQuestionIndex = (_currentQuestionIndex + 1) % widget.quiz.questions.length;
                    });
                  },
                  child: Text('Skip'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final currentQuestion = widget.quiz.questions[_currentQuestionIndex];
                    final isCorrect = _selectedOption == currentQuestion.correctOption;
                    final questionId = currentQuestion.id;
                    if (isCorrect) {
                      _correctAnswers.add(questionId);
                      _incorrectAnswers.remove(questionId);
                      _showCorrectSplash();
                    } else {
                      _incorrectAnswers.add(questionId);
                      _correctAnswers.remove(questionId);
                      _showIncorrectSplash();
                    }
                    print('Question ${_currentQuestionIndex + 1} is ${isCorrect ? 'correct' : 'incorrect'}');

                    Future.delayed(Duration(seconds: 1), () {
                      if (_currentQuestionIndex + 1 >= widget.quiz.questions.length) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Quiz Completed'),
                            content: Text(
                              'Correct: ${_correctAnswers.length}\nIncorrect: ${_incorrectAnswers.length}',
                              style: TextStyle(fontSize: 18),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close dialog
                                  Navigator.of(context).pop(); // Go back to QuizView
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        setState(() {
                          _selectedOption = null;
                          _currentQuestionIndex++;
                        });
                      }
                    });
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
