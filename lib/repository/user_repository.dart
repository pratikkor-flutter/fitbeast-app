import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbeast/models/user_model.dart';
import 'package:hive/hive.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> getUser() async {
    // from hive
    UserModel? user = getUserFromHive();

    if (user != null) {
      return user;
    }

    // if not found in hive, then fetch from firebase
    String? uid = _auth.currentUser?.uid;
    if (uid != null) {
      user = await getUserFromFirebase(uid);
      // add to hive
      await setUserInHive(user!);
    }
    return user;
  }

  Future<void> setUser(UserModel user) async {
    // add to hive
    await setUserInHive(user);

    // add to firebase
    await setUserInFirebase(user);
  }

  Future<void> updateUser(UserModel user) async {
    // update into hive
    await setUserInHive(user);

    // update into firebase
    await setUserInFirebase(user);
  }

  Future<void> setUserInHive(UserModel user) async {
    final box = Hive.box<UserModel>('users');
    await box.put('currentUser', user);
  }

  Future<void> setUserInFirebase(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(user.toJson(), SetOptions(merge: true));
  }

  UserModel? getUserFromHive() {
    final box = Hive.box<UserModel>('users');
    UserModel? user = box.get('currentUser');

    return user;
  }

  Future<UserModel?> getUserFromFirebase(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _firestore.collection('users').doc(uid).get();

    return doc.exists && doc.data() != null
        ? UserModel.fromJson(doc.data()!)
        : null;
  }
}
