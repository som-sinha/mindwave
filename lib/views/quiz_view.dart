import 'package:flutter/material.dart';
import 'package:mindwave/models/quiz_model.dart';
import 'package:mindwave/models/subtopic_model.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  SubtopicModel? subtopic;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is SubtopicModel && subtopic == null) {
      subtopic = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (subtopic == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Quiz page')),
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.spaceAround,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 40.0,
            children: [
              _buildQuizCard('Generated Quiz', 'A quiz generated using AI with questions we think would help you best revise for this specific topic.', subtopic!.genQuiz),
              _buildQuizCard('Revision Quiz', 'All the questions that you have got wrong and/or have flagged to review.', subtopic!.reviewQuiz),
              ...subtopic!.userQuizzes.asMap().entries.map((entry) {
                return _buildQuizCard('Custom Quiz ${entry.key + 1}', 'Custom Quiz made by the user...', entry.value);
              }).toList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuizCard(String title, String description, QuizModel quiz) {
    return Container(
      width: 400,
      height: 220,
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.purpleAccent[400],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 24, color: Colors.white)),
          Text(description, style: TextStyle(fontSize: 15, color: Colors.white)),
          SizedBox(height: 10),
          OverflowBar(
            alignment: MainAxisAlignment.end,
            spacing: 8.0,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text('View'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/quizStart', arguments: quiz);
                },
                child: Text('Start'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}