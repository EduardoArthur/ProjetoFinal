import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String animalKind;
  String? userId;
  String? ongId;
  GeoPoint location;
  String? message;
  bool solved;
  Timestamp? timestamp;
  String? id;
  String? imgUrl;

  Report({
    required this.animalKind,
    this.userId,
    this.ongId,
    required this.location,
    this.message,
    this.solved = false,
    this.timestamp,
    this.imgUrl,
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
      imgUrl: data?['imgUrl'],
    );
  }

  factory Report.fromFirestore(DocumentSnapshot snapshot) {

    final data = snapshot.data() as Map<String, dynamic>?;

    Report report = Report(
      animalKind: data?['animalKind'],
      userId: data?['userId'],
      ongId: data?['ongId'],
      location: data?['location'],
      message: data?['message'],
      solved: data?['solved'] ?? false,
      timestamp: data?['timestamp'],
      imgUrl: data?['imgUrl'],
    );

    report.id = data?['id'];

    return report;
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
      'imgUrl': imgUrl,
    };
  }
}