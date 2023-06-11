import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

import 'package:tcc/domain/enumeration/AnimalKind.dart';
import 'package:tcc/domain/report.dart';
import 'package:tcc/domain/user.dart';
import 'package:tcc/repository/user_repository.dart';
import 'package:tcc/repository/report_repository.dart';

class ReportService {
  final userRepository = UserRepository();
  final reportRepository = ReportRepository();

  // Metodo para gerar timestamp, ids, etc..
  Report buildNewReport(User user, LatLng location, AnimalKind animalKind, String message){

    var geoPoint = GeoPoint(location.latitude, location.longitude);

    Report report = Report(animalKind: animalKind.name, location: geoPoint);

    report.userId = user.id;
    report.message = message;
    report.timestamp = Timestamp.now();

    return report;
  }

  createNewReport(Report report, User user) async {
    // Adiciona denuncia ao banco
    final reportId = await reportRepository.addReport(report);

    if(user == null || user.id == null){
      return;
    }

    var updateList = user.reports;

    final updates = <String, dynamic>{
      "id": reportId,
      "timestamp": report.timestamp,
      "solved": report.solved
    };

    // Adiciona na lista de denuncias
    updateList ??= [];
    updateList.add(updates);

    final field = <String, dynamic>{
      "reports": updateList,
    };

    // Atualiza usuario com a nova lista de denuncias
    if(user.id != null) {
      await userRepository.updateUser(user.id!, field);
    }
  }


}
