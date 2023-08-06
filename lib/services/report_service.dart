import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';

import 'package:tcc/domain/enumeration/AnimalKind.dart';
import 'package:tcc/domain/report.dart';
import 'package:tcc/repository/report_repository.dart';

class ReportService {
  final reportRepository = ReportRepository();

  // Metodo para gerar timestamp, ids, etc..
  Report buildNewReport(User? user, LatLng location, AnimalKind animalKind, String message){

    var geoPoint = GeoPoint(location.latitude, location.longitude);

    Report report = Report(animalKind: animalKind.name, location: geoPoint);

    report.userId = user?.uid;
    report.message = message;
    report.timestamp = Timestamp.now();

    return report;
  }

  createNewReport(Report report, User? user) async {
    // Adiciona denuncia ao banco
    final reportId = await reportRepository.addReport(report);

    final field = <String, dynamic>{
           "id": reportId,
    };

    await reportRepository.updateReport(reportId, field);

  }

  setSolvedReport(Report report, bool solved) async {

    FirebaseAuth _auth = FirebaseAuth.instance;

    final field = <String, dynamic>{
      "solved": solved,
      "ongId": _auth.currentUser?.displayName,
    };

    await reportRepository.updateReport(report.id!, field);

  }

  Future<List<Report>> getUnsolvedReports(AnimalKind? animalKind) async {
    if(animalKind == null) {
      return await reportRepository.findUnsolvedReports();
    }

    return await reportRepository.findUnsolvedReportsByAnimalKind(animalKind);
  }

  Future<List<Report>> getReportsByUser(User? user) async {

    final reports = await reportRepository.findReportsByUser(user!.uid);

    return reports;

  }


}
