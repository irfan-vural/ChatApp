import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  Future updateUserData(String name, String email) async {
    await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'groups': [],
      'profile_pic': '',
      'uid': uid,
    });
  }
}
