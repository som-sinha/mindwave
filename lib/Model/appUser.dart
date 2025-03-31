import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String? id;
  final String name;

  // Constructor
  AppUser({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  static AppUser fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      name: data['name'] ?? '',
    );
  }
}
