import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/quiz_controller.dart';
import '../utils/feedback_dialog.dart';
import '../models/quiz_model.dart';

class QuizView extends StatelessWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<QuizController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.workspace_premium_outlined),
            tooltip: 'Upgrade to Pro',
            onPressed: () => controller.navigateToQuiz(context, 'upgrade'),
          ),
          IconButton(
            icon: const Icon(Icons.feedback_outlined),
            onPressed: () => showFeedbackDialog(context),
          ),
        ],
      ),
      body: Consumer<QuizController>(
        builder: (context, controller, child) {
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

    // Wrap your existing Container with Dismissible
    return Dismissible(
      key: Key(quiz.id), // Unique key for each quiz
      direction: DismissDirection.endToStart, // Only allow swipe from right to left
      background: _buildDeleteBackground(), // Red background when swiping
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
                // Added delete icon button
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.white,
                  onPressed: () => _showDeleteConfirmation(context).then((confirmed) {
                    if (confirmed ?? false) {
                      _handleQuizDeletion(context, quiz);
                    }
                  }),
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
    if (controller.isGeneratedQuiz(quiz)) {
      return 'Generated Quiz';
    } else if (controller.isRevisionQuiz(quiz)) {
      return 'Revision Quiz';
    } else {
      return 'Quiz ${controller.quizzes.indexOf(quiz) + 1}';
    }
  }

  String _getQuizDescription(BuildContext context, QuizModel quiz) {
    final controller = Provider.of<QuizController>(context, listen: false);
    if (controller.isGeneratedQuiz(quiz)) {
      return 'AI-generated questions for optimal revision';
    } else if (controller.isRevisionQuiz(quiz)) {
      return 'Questions you got wrong or flagged for review';
    } else {
      return 'Custom Quiz created by user';
    }
  }

  Color _getQuizColor(BuildContext context, QuizModel quiz) {
    final controller = Provider.of<QuizController>(context, listen: false);
    return controller.isGeneratedQuiz(quiz)
        ? Colors.purpleAccent[400]!
        : Colors.purpleAccent;
  }

  // Helper widget for swipe-to-delete background
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

// Shows confirmation dialog
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

// Handles the actual deletion
  void _handleQuizDeletion(BuildContext context, QuizModel quiz) {
    final controller = Provider.of<QuizController>(context, listen: false);
    controller.deleteQuiz(quiz.id);

    // Show undo snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted quiz'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // You'll need to add a restoreQuiz method to your controller
            controller.addQuiz(quiz);
          },
        ),
      ),
    );
  }

  void _showAddQuizDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Quiz'),
        content: const Text('This will create a new empty quiz'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<QuizController>(context, listen: false)
                  .addCustomQuiz([]);
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}