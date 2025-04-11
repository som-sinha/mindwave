import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../models/topic_model.dart';
import '../models/subtopic_model.dart';
import 'subtopic_view.dart'; // Will be implemented in Step 3

class TopicListView extends StatelessWidget {
  final CourseModel course;

  const TopicListView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.courseName)),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: course.topics.length,
        itemBuilder: (context, topicIndex) {
          final TopicModel topic = course.topics[topicIndex];

          return ExpansionTile(
            title: Text(
              topic.topicName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children:
                topic.quizzes.map((subtopic) {
                  return ListTile(
                    title: Text(subtopic.subtopicName),
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
          );
        },
      ),
    );
  }
}
