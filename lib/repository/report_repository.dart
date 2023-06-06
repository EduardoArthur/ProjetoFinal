import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tcc/domain/report.dart';
import 'package:tcc/domain/user.dart';

class ReportRepository {
  final CollectionReference reportsCollection =
  FirebaseFirestore.instance.collection('report');

  // create a new document with an automatically generated ID
  Future<String> addReport(Report report) async {
      return await reportsCollection.add(report.toFirestore()).then(
              (documentSnapshot) => documentSnapshot.id);
  }

  // create or update a document at a specific location
  Future<void> setReport(String id, Report report) async {
    await reportsCollection.doc(id).set(report.toFirestore());
  }

  // update specific fields within a document
  Future<void> updateReport(String id, Map<String, dynamic> field) async {
    await reportsCollection.doc(id).update(field);
  }

  Future<void> deleteReport(String id) async {
      await reportsCollection.doc(id).delete();
  }

  Future<Iterable> getAllReports() async {
    final snapshot = await reportsCollection.get();
    return snapshot.docs.map((doc) => doc.data());
  }

  Future<Report?> findReportById(String id) async {
    final DocumentSnapshot snapshot =
    await reportsCollection.doc(id).get();

    if (snapshot.exists) {
      return Report.fromFirestore(snapshot);
    }

    return null;
  }

}