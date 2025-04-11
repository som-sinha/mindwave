import 'package:flutter/material.dart';
import '../models/subtopic_model.dart';

class SubtopicView extends StatelessWidget {
  final SubtopicModel subtopic;

  const SubtopicView({super.key, required this.subtopic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subtopic.subtopicName),
        leading: BackButton(),
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
          // Banner / Header
          Container(
            width: double.infinity,
            height: 160,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://dummyimage.com/800x400/aaaaff/ffffff',
                ),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                subtopic.subtopicName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Quiz Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                // TODO: Navigate to quiz view
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
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Go through our suggested questions or make your own! We keep track of where you went wrong so you can review later.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Review Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/review',
                  arguments: {
                    'subtopicName': subtopic.subtopicName,
                    'summary':
                        'This is a placeholder summary for ${subtopic.subtopicName}. You can generate this dynamically using AI or content stored in the subtopic later.',
                  },
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
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Use the power of AI to get a head start on the topic before getting quizzed!',
                      style: TextStyle(fontSize: 14),
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
