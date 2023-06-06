import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tcc/domain/user.dart';

class UserRepository {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('user');

  // create a new document with an automatically generated ID
  Future<User> addUser(User user) async {

    user.reports ??= [];

    user.id = await usersCollection.add(user.toFirestore()).then(
            (documentSnapshot) => documentSnapshot.id);

    return user;
  }

  // create or update a document at a specific location
  Future<void> saveUser(String id, User user) async {
    await usersCollection.doc(id).set(user.toFirestore());
  }

  // update specific fields within a document
  Future<void> updateUser(String id, Map<String, dynamic> field) async {
    await usersCollection.doc(id).update(field);
  }

  Future<void> deleteUser(String id) async {
    await usersCollection.doc(id).delete();
  }

  Future<Iterable> getAllUsers() async {
    final snapshot = await usersCollection.get();
    return snapshot.docs.map((doc) => doc.data());
  }

  Future<User?> findUserById(String id) async {
    final DocumentSnapshot snapshot =
    await usersCollection.doc(id).get();

    if (snapshot.exists) {
      return User.fromFirestore(snapshot);
    }

    return null;
  }


}