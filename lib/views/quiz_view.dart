import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/quiz_controller.dart';
import '../utils/feedback_dialog.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';

class QuizView extends StatelessWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.workspace_premium_outlined),
            tooltip: 'Upgrade to Pro',
            onPressed: () => Navigator.pushNamed(context, '/upgrade'),
          ),
          IconButton(
            icon: const Icon(Icons.feedback_outlined),
            onPressed: () => showFeedbackDialog(context),
          ),
        ],
      ),
      body: Consumer<QuizController>(
        builder: (context, controller, child) {
          if (controller.quizzes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Align(
            alignment: Alignment.center,
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 40.0,
              children: controller.quizzes.map((quiz) => _buildQuizCard(context, quiz)).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddQuizDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, QuizModel quiz) {
    final title = _getQuizTitle(context, quiz);
    final description = _getQuizDescription(context, quiz);
    final color = _getQuizColor(context, quiz);

    return Dismissible(
      key: Key(quiz.id),
      direction: DismissDirection.endToStart,
      background: _buildDeleteBackground(),
      confirmDismiss: (direction) => _showDeleteConfirmation(context),
      onDismissed: (direction) => _handleQuizDeletion(context, quiz),
      child: Container(
        width: 400,
        height: 220,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
            const SizedBox(height: 10),
            OverflowBar(
              alignment: MainAxisAlignment.end,
              spacing: 8.0,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.white,
                  onPressed: () async {
                    final confirmed = await _showDeleteConfirmation(context);
                    if (confirmed == true) {
                      _handleQuizDeletion(context, quiz);
                    }
                  },
                ),
                ElevatedButton(
                    onPressed: () {},
                    child: const Text('View')
                ),
                ElevatedButton(
                  onPressed: () => Provider.of<QuizController>(context, listen: false)
                      .navigateToQuiz(context, quiz.id),
                  child: const Text('Start'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getQuizTitle(BuildContext context, QuizModel quiz) {
    final controller = Provider.of<QuizController>(context, listen: false);
    if (quiz == controller.generatedQuiz) {
      return 'Generated Quiz';
    } else if (quiz == controller.revisionQuiz) {
      return 'Revision Quiz';
    } else {
      return 'Quiz ${controller.quizzes.indexOf(quiz) + 1}';
    }
  }

  String _getQuizDescription(BuildContext context, QuizModel quiz) {
    final controller = Provider.of<QuizController>(context, listen: false);
    if (quiz == controller.generatedQuiz) {
      return 'AI-generated questions for optimal revision';
    } else if (quiz == controller.revisionQuiz) {
      return 'Questions you got wrong or flagged for review';
    } else {
      return 'Custom Quiz created by user';
    }
  }

  Color _getQuizColor(BuildContext context, QuizModel quiz) {
    final controller = Provider.of<QuizController>(context, listen: false);
    return quiz == controller.generatedQuiz
        ? Colors.purpleAccent[400]!
        : Colors.purpleAccent;
  }

  Widget _buildDeleteBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8.0),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
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
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleQuizDeletion(BuildContext context, QuizModel quiz) async {
    final controller = Provider.of<QuizController>(context, listen: false);
    try {
      await controller.deleteQuiz(quiz.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Quiz deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await controller.addQuizFromModel(quiz);
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete quiz: ${e.toString()}')),
      );
    }
  }

  Future<void> _showAddQuizDialog(BuildContext context) async {
    final controller = Provider.of<QuizController>(context, listen: false);

    final result = await showDialog<QuizModel>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Quiz'),
        content: const Text('Enter a title for your new quiz'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Create with at least one default question
              final defaultQuestion = QuestionModel(
                  "New Question",
                  "A",
                  {"A": "Option A", "B": "Option B"}
              );

              final newQuiz = await controller.addQuiz([defaultQuestion]);
              Navigator.pop(context, newQuiz);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (result != null) {
      Navigator.pushNamed(
        context,
        '/edit-quiz',
        arguments: result.id,
      );
    }
  }
}