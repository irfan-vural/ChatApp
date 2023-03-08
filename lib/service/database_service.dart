import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  Future savingUserData(String name, String email) async {
    await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'groups': [],
      'profile_pic': '',
      'uid': uid,
    });
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  Future getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }
}
