import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String userName;


  // Constructor
  UserModel({
    this.id,
    required this.userName,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
    };
  }

  static UserModel fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      userName: data['name'] ?? '',
    );
  }
}
