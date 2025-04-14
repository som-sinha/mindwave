import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mindwave/controllers/app_controller.dart';
import 'package:provider/provider.dart';
import '../models/subtopic_model.dart';
import '../models/quiz_model.dart';

class SubtopicView extends StatefulWidget {
  final SubtopicModel subtopic;

  const SubtopicView({super.key, required this.subtopic});

  @override
  State<SubtopicView> createState() => _SubtopicViewState(subtopic: subtopic);
}
  
class _SubtopicViewState extends State<SubtopicView> {

  final SubtopicModel subtopic;

  _SubtopicViewState({required this.subtopic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8EDF8),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        title: Text(subtopic.subtopicName.isNotEmpty ? subtopic.subtopicName : 'Subtopic Title'),
        leading: const BackButton(),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://dummyimage.com/600x400/000/fff.png',
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Subtopic Name
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              subtopic.subtopicName.isNotEmpty ? subtopic.subtopicName : 'Subtopic Title',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Quiz Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/quiz',
                  arguments: {subtopic.genQuiz, subtopic.reviewQuiz, subtopic.userQuizzes}
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFEAD8F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quiz',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Go through our suggested questions or make your own! We keep track of where you went wrong so you can review later.',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Review Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/review',
                  arguments: {
                    'subtopicName': subtopic.subtopicName,
                    'summary': subtopic.description
                  }
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFEAD8F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Use the power of AI to get a head start on the topic before getting quizzed!',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
