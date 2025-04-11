import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../models/topic_model.dart';
import '../models/subtopic_model.dart';
import 'subtopic_view.dart';

class TopicListView extends StatelessWidget {
  final CourseModel course;

  const TopicListView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8EDF8),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        title: Text(course.courseName),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: course.topics.length,
        itemBuilder: (context, topicIndex) {
          final TopicModel topic = course.topics[topicIndex];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                topic.topicName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              children:
                  topic.quizzes.map((subtopic) {
                    return ListTile(
                      title: Text(subtopic.subtopicName),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubtopicView(subtopic: subtopic),
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),
          );
        },
      ),
    );
  }
}
