import 'package:firebase_auth/firebase_auth.dart';
import '../domain/ong.dart';
import '../repository/ong_repository.dart';

class OngService {

  final OngRepository ongRepository = OngRepository();

  Future<void> createOng(String nome, String cnpj, User user) async {
    await ongRepository.setOng(user.uid, Ong(nome: nome, cnpj: cnpj));
  }

  Future<bool> existOng(User user) async {
    return await ongRepository.findOngById(user.uid) != null;
  }

}