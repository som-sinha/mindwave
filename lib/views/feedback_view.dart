import 'package:flutter/material.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  _FeedbackViewState createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  final List<String> sections = [
    'User Profiles',
    'Tutoring Mode',
    'Generate Quizzes/Flashcards',
    'Summarise',
    'Learning Resources',
    'Progress Tracking & Analytics',
    'Optional Features'
  ];


  late Map<String, int> ratings;
  late Map<String, TextEditingController> feedbackControllers;

  @override
  void initState() {
    super.initState();
    ratings = { for (var section in sections) section: 0 };
    feedbackControllers = { for (var section in sections) section: TextEditingController() };
  }

  @override
  void dispose() {
    for (var controller in feedbackControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildRatingStars(String section) {
    int currentRating = ratings[section] ?? 0;
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              ratings[section] = index + 1;
            });
          },
        );
      }),
    );
  }

  Widget _buildSectionFeedback(String section) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(section),
            const SizedBox(height: 10),
            _buildRatingStars(section),
            const SizedBox(height: 10),
            TextField(
              controller: feedbackControllers[section],
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Comments for $section',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitFeedback() {
    for (var section in sections) {
      print('Section: $section');
      print('Rating: ${ratings[section]}');
      print('Comments: ${feedbackControllers[section]!.text}');
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ThankYouPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MindWave Feedback'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Please rate and provide feedback for the following sections:',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ...sections.map((section) => _buildSectionFeedback(section)).toList(),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _submitFeedback,
              child: const Text('Submit Feedback'),
            ),
          ),
        ],
      ),
    );
  }
}

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({super.key});

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.pushReplacementNamed(context, '/home');
      });
    });

    return Scaffold(
      body: const Center(
        child: Text(
          'Thank you for submitting!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}