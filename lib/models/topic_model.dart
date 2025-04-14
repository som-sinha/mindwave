import 'subtopic_model.dart';
import 'package:uuid/uuid.dart';

class TopicModel {
  String id;
  String topicName;
  List<SubtopicModel> subtopics;
  
  TopicModel(this.topicName, this.subtopics) : id = Uuid().v4();

  factory TopicModel.fromFirestore(Map<String, dynamic> data) {
    return TopicModel(
      data['topicName'] ?? '',
      [], // subtopics can be fetched separately
    )..id = data['id'] ?? Uuid().v4();
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'topicName': topicName,
      'subtopics': subtopics.map((st) => st.subtopicName).toList(),
    };
  }  
}