import 'package:cloud_firestore/cloud_firestore.dart';

class Ong{

  String nome;
  String cnpj;

  Ong({
    required this.nome,
    required this.cnpj,
  });


  factory Ong.fromMap(Map<String, dynamic>? data) {

    return Ong(
      nome: data?['nome'],
      cnpj: data?['cnpj'],
    );
  }

  factory Ong.fromFirestore(DocumentSnapshot snapshot) {

    final data = snapshot.data() as Map<String, dynamic>?;

    return Ong(
      nome: data?['nome'],
      cnpj: data?['cnpj'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'cnpj': cnpj,
    };
  }
}