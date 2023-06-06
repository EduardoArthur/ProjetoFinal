import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String animalId;
  String? userId;
  String? ongId;
  GeoPoint location;
  String? message;
  bool solved;
  Timestamp? timestamp;

  Report({
    required this.animalId,
    this.userId,
    this.ongId,
    required this.location,
    this.message,
    this.solved = false,
    this.timestamp,
  });

  factory Report.fromMap(Map<String, dynamic>? data) {

    return Report(
      animalId: data?['animalId'],
      userId: data?['userId'],
      ongId: data?['ongId'],
      location: data?['location'],
      message: data?['message'],
      solved: data?['solved'] ?? false,
      timestamp: data?['timestamp'],
    );
  }

  factory Report.fromFirestore(DocumentSnapshot snapshot) {

    final data = snapshot.data() as Map<String, dynamic>?;

    return Report(
      animalId: data?['animalId'],
      userId: data?['userId'],
      ongId: data?['ongId'],
      location: data?['location'],
      message: data?['message'],
      solved: data?['solved'] ?? false,
      timestamp: data?['timestamp'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'animalId': animalId,
      'userId': userId,
      'ongId': ongId,
      'location': location,
      'message': message,
      'solved': solved,
      'timestamp': timestamp,
    };
  }
}