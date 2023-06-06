import 'package:tcc/domain/report.dart';
import 'package:tcc/domain/user.dart';
import 'package:tcc/repository/user_repository.dart';
import 'package:tcc/repository/report_repository.dart';

class ReportService {
  final userRepository = UserRepository();
  final reportRepository = ReportRepository();

  // Metodo para gerar timestamp, ids, etc..
  buildNewReport(){

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
