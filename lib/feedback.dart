import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // Define the sections for which feedback is needed.
  final List<String> sections = [
    'User Profiles',
    'Tutoring Mode',
    'Generate Quizzes/Flashcards',
    'Summarise',
    'Learning Resources',
    'Progress Tracking & Analytics',
    'Optional Features'
  ];

  // Map to hold ratings for each section.
  late Map<String, int> ratings;
  // Map to hold text controllers for comments for each section.
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

  // Build a custom star rating row for a given section.
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

  // Build the feedback widget for a given section.
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

  // Handle submission of the feedback.
  void _submitFeedback() {
    // Process feedback for each section.
    for (var section in sections) {
      print('Section: $section');
      print('Rating: ${ratings[section]}');
      print('Comments: ${feedbackControllers[section]!.text}');
    }
    // Display a confirmation message.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thanks for your feedback!")),
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
          // Build feedback sections dynamically.
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
