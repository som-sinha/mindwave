// lib/views/review_view.dart
import 'package:flutter/material.dart';

class ReviewView extends StatelessWidget {
  final String subtopicName;
  final String summary;

  const ReviewView({
    super.key,
    required this.subtopicName,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review: $subtopicName')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(summary, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
