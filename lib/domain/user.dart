import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String name;
  String email;
  List<Map<String, dynamic>>? reports;

  User({
    this.id,
    required this.name,
    required this.email,
    this.reports,
  });

  factory User.fromMap(Map<String, dynamic>? data) {

    return User(
      id: data?['id'],
      name: data?['name'],
      email: data?['email'],
      reports: (data?['reports'] as List<dynamic>).map((reportData) {
        return {
          'id': reportData['id'],
          'timestamp': reportData['timestamp'],
          'solved': reportData['solved'],
        };
      }).toList(),
    );
  }

  factory User.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    return User(
      id: data?['id'],
      name: data?['name'],
      email: data?['email'],
      reports: (data?['reports'] as List<dynamic>).map((reportData) {
        return {
          'id': reportData['id'],
          'timestamp': reportData['timestamp'],
          'solved': reportData['solved'],
        };
      }).toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'reports': reports,
    };
  }
}