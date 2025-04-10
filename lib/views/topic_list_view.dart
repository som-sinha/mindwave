import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mindwave/controllers/app_controller.dart';
import 'package:mindwave/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import '../models/topic_model.dart';
import 'subtopic_view.dart';

class TopicListView extends StatefulWidget {
  final String courseid;

  const TopicListView({super.key, required this.courseid});

  @override
  State<TopicListView> createState() => _TopicListViewState(courseid: courseid);
}

class _TopicListViewState extends State<TopicListView> {
  late Future<void> _topicFuture;
  var userId = '';
  final String courseid;

  _TopicListViewState({required this.courseid});

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    _topicFuture = context.read<AppController>().fetchTopics(userId ,widget.courseid);
  }

  @override
  Widget build(BuildContext context) {
    final appCtrl = context.watch<AppController>();
    final authCtrl = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: Color(0xFFF8EDF8),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        title: Text('Topics'),
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
      body: FutureBuilder<List<TopicModel>>(
        future: context.read<AppController>().fetchTopics(userId, courseid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No topics found.'));
          }

          final topics = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: topics.length,
            itemBuilder: (context, topicIndex) {
              final TopicModel topic = topics[topicIndex];

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
                  children: topic.subtopics.map((subtopic) {
                    return ListTile(
                      title: Text(subtopic.subtopicName),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/subtopic',
                          arguments: {
                            subtopic
                          }
                        );
                    },
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
