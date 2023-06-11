import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/domain/enumeration/AnimalKind.dart';

class Report {
  String animalKind;
  String? userId;
  String? ongId;
  GeoPoint location;
  String? message;
  bool solved;
  Timestamp? timestamp;

  Report({
    required this.animalKind,
    this.userId,
    this.ongId,
    required this.location,
    this.message,
    this.solved = false,
    this.timestamp,
  });

  factory Report.fromMap(Map<String, dynamic>? data) {

    return Report(
      animalKind: data?['animalKind'],
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
      animalKind: data?['animalKind'],
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
      'animalKind': animalKind,
      'userId': userId,
      'ongId': ongId,
      'location': location,
      'message': message,
      'solved': solved,
      'timestamp': timestamp,
    };
  }
}