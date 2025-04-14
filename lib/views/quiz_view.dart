import 'package:flutter/material.dart';
import '../models/quiz_model.dart';

class QuizView extends StatelessWidget {
  final QuizModel? genQuiz;
  final QuizModel? reviewQuiz;
  final List<QuizModel> userQuizzes;

  const QuizView({
    super.key,
    required this.genQuiz,
    required this.reviewQuiz,
    required this.userQuizzes,
  });

  @override
  Widget build(BuildContext context) {
    final allQuizzes = [
      if (genQuiz != null) {'quiz': genQuiz!, 'label': 'Generated Quiz'},
      if (reviewQuiz != null) {'quiz': reviewQuiz!, 'label': 'Review Quiz'},
      ...userQuizzes.map((q) => {'quiz': q, 'label': 'User Quiz'}),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quizzes"),
      ),
      body: allQuizzes.isEmpty
          ? const Center(child: Text('No review questions available.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 40.0,
                children: allQuizzes
                    .map((data) => _buildQuizCard(
                        context, data['quiz'] as QuizModel, data['label'] as String))
                    .toList(),
              ),
            ),
    );
  }

  Widget _buildQuizCard(BuildContext context, QuizModel quiz, String label) {
    return Dismissible(
      key: Key(quiz.id),
      direction: DismissDirection.endToStart,
      background: _buildDeleteBackground(),
      confirmDismiss: (direction) => _showDeleteConfirmation(context),
      onDismissed: (direction) {
        _handleQuizDeletion(context, quiz);
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            OverflowBar(
              alignment: MainAxisAlignment.end,
              spacing: 8.0,
              children: [
                if (quiz != genQuiz)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final confirmed = await _showDeleteConfirmation(context);
                      if (confirmed == true) {
                        _handleQuizDeletion(context, quiz);
                      }
                    },
                  ),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('$label Questions'),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: quiz.questions.length,
                                itemBuilder: (context, index) {
                                  final q = quiz.questions[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${index + 1}. ${q.question}',
                                            style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ...q.options.map((opt) => Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Text('- $opt'),
                                            )),
                                        const Divider(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('View')
                ),
                ElevatedButton(
                  onPressed: () {
                    if (quiz.questions.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('No Questions'),
                          content: const Text('This quiz has no questions available.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      Navigator.pushNamed(
                        context,
                        '/quizStart',
                        arguments: quiz,
                      );
                    }
                  },
                  child: const Text('Start'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }
  
  Widget _buildDeleteBackground() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(
        Icons.delete,
        size: 30,
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quiz'),
        content: const Text('Are you sure you want to delete this quiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleQuizDeletion(BuildContext context, QuizModel quiz) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Quiz "${quiz.id}" deleted.')),
    );
  }
}