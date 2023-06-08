import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tcc/domain/ong.dart';

class OngRepository {
  final CollectionReference ongsCollection =
  FirebaseFirestore.instance.collection('ong');

  // create a new document with an automatically generated ID
  Future<String> addOng(Ong ong) async {
    return await ongsCollection.add(ong.toFirestore()).then(
            (documentSnapshot) => documentSnapshot.id);
  }

  // create or update a document at a specific location
  Future<void> setOng(String id, Ong ong) async {
    await ongsCollection.doc(id).set(ong.toFirestore());
  }

  // update specific fields within a document
  Future<void> updateOng(String id, Map<String, dynamic> field) async {
    await ongsCollection.doc(id).update(field);
  }

  Future<void> deleteOng(String id) async {
    await ongsCollection.doc(id).delete();
  }

  Future<Iterable> getAllOngs() async {
    final snapshot = await ongsCollection.get();
    return snapshot.docs.map((doc) => doc.data());
  }

  Future<Ong?> findOngById(String id) async {
    final DocumentSnapshot snapshot =
    await ongsCollection.doc(id).get();

    if (snapshot.exists) {
      return Ong.fromFirestore(snapshot);
    }

    return null;
  }

}